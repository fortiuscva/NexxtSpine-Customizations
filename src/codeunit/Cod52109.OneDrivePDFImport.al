codeunit 52109 "NTS OneDrive PDF Import"
{
    [TryFunction]
    procedure ImportPDFFromOneDrive()
    var
        OneDriveConfig: Record "NTS OneDrive Configuration";

        Client: HttpClient;
        Response: HttpResponseMessage;
        Request: HttpRequestMessage;
        Content: HttpContent;
        Headers: HttpHeaders;

        JsonTxt: Text;
        RootObj: JsonObject;
        Token: JsonToken;
        FilesArray: JsonArray;
        FileToken: JsonToken;

        AccessToken: Text;
    begin
        OneDriveConfig.Get();

        AccessToken := GetAccessToken(OneDriveConfig);

        Headers := Client.DefaultRequestHeaders();
        Headers.Add('Authorization', StrSubstNo('Bearer %1', AccessToken));

        Request.SetRequestUri(
            StrSubstNo(
                'https://graph.microsoft.com/v1.0/drives/%1/root:/BCOneDrive/Attachments:/children',
                GetDriveId()
            )
        );
        Request.Method := 'GET';

        Client.Send(Request, Response);

        Response.Content().ReadAs(JsonTxt);
        RootObj.ReadFrom(JsonTxt);

        RootObj.Get('value', Token);
        FilesArray := Token.AsArray();

        foreach FileToken in FilesArray do
            ProcessSingleFile(FileToken, AccessToken);
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

        AttachToItem(Staging);
    end;

    local procedure AttachToItem(var Staging: Record "NTS OneDrive File Staging")
    var
        Item: Record Item;
        DocAttach: Record "Document Attachment";
        InStr: InStream;
        ItemNo: Code[20];
    begin
        ItemNo := GetItemNoFromFileName(Staging."File Name");

        if not Item.Get(ItemNo) then begin
            Staging."Error Message" := 'Item not found';
            Staging.Modify();
            exit;
        end;

        DocAttach.Init();
        DocAttach."Table ID" := Database::Item;
        DocAttach."No." := Item."No.";
        DocAttach."Line No." := 0;

        DocAttach."File Name" := Staging."File Name";
        DocAttach."File Extension" := 'pdf';
        DocAttach."File Type" :=
            DocAttach."File Type"::PDF;

        DocAttach."Attached Date" := CurrentDateTime();
        DocAttach."Attached By" := UserSecurityId();
        DocAttach.User := UserId();

        Staging."File Content".CreateInStream(InStr);
        DocAttach."Document Reference ID".ImportStream(
            InStr,
            Staging."File Name"
        );

        DocAttach.Insert(true);

        Staging."Processed" := true;
        Staging.Modify();
    end;

    local procedure GetItemNoFromFileName(FileName: Text): Code[20]
    var
        Pos: Integer;
    begin
        Pos := StrPos(FileName, ' ');
        if Pos = 0 then
            exit('');

        exit(CopyStr(FileName, 1, Pos - 1));
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
