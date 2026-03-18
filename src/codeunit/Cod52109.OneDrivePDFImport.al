codeunit 52109 "NTS OneDrive PDF Import"
{
    [TryFunction]
    procedure ImportPDFFromOneDrive()
    var
        OneDriveConfig: Record "NTS OneDrive Configuration";
        AccessToken: Text;
        Url: Text;
    begin
        OneDriveConfig.Get();

        AccessToken := GetAccessToken(OneDriveConfig);

        Url :=
          'https://graph.microsoft.com/v1.0/users/ldavis%40nexxtspine.com/drive/root:/Attachments:/children';

        ReadAllFiles(Url, AccessToken);
    end;

    local procedure ReadAllFiles(Url: Text; AccessToken: Text)
    var
        Client: HttpClient;
        Response: HttpResponseMessage;
        Headers: HttpHeaders;
        JsonTxt: Text;
        RootObj: JsonObject;
        Token: JsonToken;
        FilesArray: JsonArray;
        FileToken: JsonToken;
        NextLink: Text;
    begin
        repeat
            Client.DefaultRequestHeaders().Clear();
            Headers := Client.DefaultRequestHeaders();
            Headers.Add('Authorization', StrSubstNo('Bearer %1', AccessToken));

            Client.Get(Url, Response);

            if not Response.IsSuccessStatusCode() then
                Error('Graph API Error: %1', Response.HttpStatusCode());

            Response.Content().ReadAs(JsonTxt);
            RootObj.ReadFrom(JsonTxt);

            if RootObj.Get('value', Token) then begin
                FilesArray := Token.AsArray();

                foreach FileToken in FilesArray do
                    ProcessSingleFile(FileToken, AccessToken);
            end;

            if RootObj.Get('@odata.nextLink', Token) then
                NextLink := Token.AsValue().AsText()
            else
                NextLink := '';

            Url := NextLink;

        until Url = '';
    end;

    local procedure ProcessSingleFile(FileToken: JsonToken; AccessToken: Text)
    var
        FileObj: JsonObject;
        Token: JsonToken;
        FileName: Text;
        ItemId: Text;
        DownloadUrl: Text;
    begin
        FileObj := FileToken.AsObject();

        if FileObj.Get('name', Token) then
            FileName := Token.AsValue().AsText();

        if not (FileName.EndsWith('.PDF') or FileName.EndsWith('.pdf')) then
            exit;

        if FileObj.Get('id', Token) then
            ItemId := Token.AsValue().AsText();

        if IsAlreadyStaged(ItemId) then
            exit;

        if FileObj.Get('@microsoft.graph.downloadUrl', Token) then
            DownloadUrl := Token.AsValue().AsText();

        DownloadAndProcessFile(FileName, ItemId, DownloadUrl, AccessToken);
    end;

    local procedure DownloadAndProcessFile(
        FileName: Text;
        ItemId: Text;
        DownloadUrl: Text;
        AccessToken: Text)
    var
        Client: HttpClient;
        Response: HttpResponseMessage;
        InStr: InStream;
        OutStr: OutStream;
        Staging: Record "NTS OneDrive File Staging";
    begin
        Client.Get(DownloadUrl, Response);
        Response.Content().ReadAs(InStr);

        Staging.Init();
        Staging."File Name" := FileName;
        Staging."File Extension" := 'PDF';
        Staging."OneDrive Item Id" := ItemId;
        Staging."Created At" := CurrentDateTime();

        Staging."File Content".CreateOutStream(OutStr);
        CopyStream(OutStr, InStr);
        Staging.Insert(true);

        AttachLinkToItem(Staging, DownloadUrl);
    end;

    local procedure AttachLinkToItem(var Staging: Record "NTS OneDrive File Staging"; DownloadUrl: Text)
    var
        Item: Record Item;
        RecLink: Record "Record Link";
        ItemNo: Code[20];
        RecId: RecordId;
    begin
        ItemNo := GetItemNoFromFileName(Staging."File Name");

        if StrLen(ItemNo) > MaxStrLen(Item."No.") then begin
            Staging."Error Message" := StrSubstNo(
                'Skipped: Item No too long (%1 chars): %2',
                StrLen(ItemNo),
                ItemNo
            );
            Staging.Modify();
            exit;
        end;

        if ItemNo = '' then begin
            Staging."Error Message" := 'Skipped: Unable to extract Item No';
            Staging.Modify();
            exit;
        end;

        Item.Reset();
        Item.SetRange("IMP Drawing Number", ItemNo);

        if not Item.FindFirst() then begin
            Staging."Error Message" := 'Item not found';
            Staging.Modify();
            exit;
        end;

        repeat
            RecId := Item.RecordId();

            RecLink.Reset();
            RecLink.SetRange("Record ID", RecId);
            RecLink.SetRange(URL1, DownloadUrl);
            if RecLink.FindSet() then
                RecLink.DeleteAll();

            Clear(RecLink);

            RecLink.Init();
            RecLink."Record ID" := RecId;
            RecLink.Description := CopyStr(Staging."File Name", 1, 100);
            RecLink.URL1 := DownloadUrl;
            RecLink.Created := CurrentDateTime();
            RecLink."User ID" := UserId();
            RecLink.Company := CompanyName;
            RecLink.Insert(true);

        until Item.Next() = 0;

        Staging."Processed" := true;
        Staging.Modify();
    end;

    local procedure GetItemNoFromFileName(FileName: Text): Code[20]
    var
        Pos: Integer;
        ResultTxt: Text;
    begin
        Pos := StrPos(FileName, ' ');

        if Pos = 0 then
            ResultTxt := FileName
        else
            ResultTxt := CopyStr(FileName, 1, Pos - 1);

        exit(CopyStr(ResultTxt, 1, 20));
    end;

    local procedure IsAlreadyStaged(ItemId: Text): Boolean
    var
        Staging: Record "NTS OneDrive File Staging";
    begin
        Staging.SetRange("OneDrive Item Id", ItemId);
        exit(Staging.FindFirst());
    end;

    local procedure GetAccessToken(OneDriveConfig: Record "NTS OneDrive Configuration"): Text
    var
        Client: HttpClient;
        Content: HttpContent;
        Headers: HttpHeaders;
        Response: HttpResponseMessage;
        JsonObj: JsonObject;
        Token: JsonToken;
        Body: Text;
        Result: Text;
    begin
        Body :=
            'grant_type=client_credentials' +
            '&client_id=' + OneDriveConfig."Client ID" +
            '&client_secret=' + OneDriveConfig."Client Secret" +
            '&scope=https://graph.microsoft.com/.default';

        Content.WriteFrom(Body);
        Content.GetHeaders(Headers);
        Headers.Remove('Content-Type');
        Headers.Add('Content-Type', 'application/x-www-form-urlencoded');

        Client.Post(
            'https://login.microsoftonline.com/' +
            OneDriveConfig."Tenant ID" +
            '/oauth2/v2.0/token',
            Content,
            Response
        );

        Response.Content().ReadAs(Result);
        JsonObj.ReadFrom(Result);
        JsonObj.Get('access_token', Token);

        exit(Token.AsValue().AsText());
    end;

    local procedure GetDriveId(): Text
    begin
        exit('b!3znlgyQjLEiwUmxakoSA8Mrc27mrAu5Eh-tlVVVfDCs5K3hE7irFTIVFnphKilgI');
    end;

    local procedure GetFolderId(): Text
    begin
        exit('BCOneDrive/Attachments');
    end;
}
