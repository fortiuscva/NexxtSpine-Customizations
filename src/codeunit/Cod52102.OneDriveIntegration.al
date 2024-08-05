codeunit 52102 "NTS OneDrive Integration"
{

    [TryFunction]
    procedure ConnectOneDriveFile(pNewFileName: Text; pFileName: Text; var pLink: Text)
    var
        OneDriveConfig: Record "NTS OneDrive Configuration";
        Base64VarLcl: Codeunit "Base64 Convert";
        ClientVarLcl: HttpClient;
        DClientVarLcl: HttpClient;
        ResponseVarLcl: HttpResponseMessage;
        DResponseVarLcl: HttpResponseMessage;
        RequestVarLcl: HttpRequestMessage;
        ContentVarLcl: HttpContent;
        HeadersVarLcl: HttpHeaders;
        DHeadersVarLcl: HttpHeaders;
        SHeadersVarLcl: HttpHeaders;
        SRequestVarLcl: HttpRequestMessage;
        SContentVarLcl: HttpContent;
        SClientVarLcl: HttpClient;
        SResponseVarLcl: HttpResponseMessage;
        Base64EncodedCredentialsVarLcl: Text;
        UrlVarLcl: Text;
        JsonObjVarLcl: JsonObject;
        JsonTokenVarLcl: JsonToken;
        TokenVarLcl: text;
        ClientIDVarLcl: text[250];
        SecretVarLcl: text[250];
        BaseTxtVarLcl: Text[1024];
        APITokenVarLcl: Text;
        InstreamVarLcl: InStream;
        C_UploadResourceLbl: Label 'uploadFile/false';
        DHeaders2VarLcl: HttpHeaders;
        DClient2VarLcl: HttpClient;
        Request2VarLcl: HttpRequestMessage;
        Content2VarLcl: HttpContent;
        DResponse2VarLcl: HttpResponseMessage;

    begin
        OneDriveConfig.GET();

        //UrlVarLcl := 'https://login.microsoftonline.com/' + 'd2d6e7c4-f146-4110-9f5d-619e5c984289' + '/oauth2/v2.0/token';
        UrlVarLcl := 'https://login.microsoftonline.com/' + OneDriveConfig."Tenant ID" + '/oauth2/v2.0/token';

        BaseTxtVarLcl := 'grant_type=client_credentials&client_id=' + OneDriveConfig."Client ID" + '&client_secret=' + OneDriveConfig."Client Secret" + '&scope=https://graph.microsoft.com/.default';
        ContentVarLcl.Clear();
        ContentVarLcl.WriteFrom(BaseTxtVarLcl);
        HeadersVarLcl.Clear();
        ContentVarLcl.GetHeaders(HeadersVarLcl);
        HeadersVarLcl.Remove('Content-Type');
        HeadersVarLcl.Add('Content-Type', 'application/x-www-form-urlencoded');
        ContentVarLcl.GetHeaders(HeadersVarLcl);
        if ClientVarLcl.Post(UrlVarLcl, ContentVarLcl, ResponseVarLcl) then begin
            ResponseVarLcl.Content().ReadAs(TokenVarLcl);
            JsonObjVarLcl.ReadFrom(TokenVarLcl);
            JsonObjVarLcl.Get('access_token', JsonTokenVarLcl);
            JsonTokenVarLcl.WriteTo(APITokenVarLcl);
            APITokenVarLcl := DelChr(APITokenVarLcl, '=', '"');

            DHeadersVarLcl := DClientVarLcl.DefaultRequestHeaders();
            DHeadersVarLcl.Add('Authorization', StrSubstNo('Bearer %1', APITokenVarLcl));

            RequestVarLcl.SetRequestUri(StrSubstNo('https://graph.microsoft.com/v1.0/drives/%1/items/root:/%2/%3:/content', '5c760bc6-498c-4d74-a063-4c2b562d6df4', OneDriveConfig."Source Folder Name", pFileName));
            RequestVarLcl.Method := 'GET';
            if DClientVarLcl.Send(RequestVarLcl, DResponseVarLcl) then
                if DResponseVarLcl.IsSuccessStatusCode() then
                    if DResponseVarLcl.Content.ReadAs(InstreamVarLcl) then begin

                        DHeaders2VarLcl := DClient2VarLcl.DefaultRequestHeaders();
                        DHeaders2VarLcl.Add('Authorization', StrSubstNo('Bearer %1', APITokenVarLcl));
                        //Request2VarLcl.SetRequestUri(StrSubstNo('https://graph.microsoft.com/v1.0/drives/%1/items/root:/%2/%3:/content', '5c760bc6-498c-4d74-a063-4c2b562d6df4', OneDriveConfig."Destination Folder Name", pNewFileName + ' ' + pFileName));
                        Request2VarLcl.SetRequestUri(StrSubstNo('https://graph.microsoft.com/v1.0/drives/%1/items/root:/%2/%3:/content', '5c760bc6-498c-4d74-a063-4c2b562d6df4', OneDriveConfig."Destination Folder Name", pNewFileName + '.xlsx'));
                        Request2VarLcl.Method := 'PUT';
                        Content2VarLcl.WriteFrom(InstreamVarLcl);
                        Request2VarLcl.Content := Content2VarLcl;
                        if DClient2VarLcl.Send(Request2VarLcl, DResponse2VarLcl) then begin
                            //pLink := 'https://nexxtspinellc-my.sharepoint.com/my?id=%2Fpersonal%2Fbcadmin_nexxtspine_com%2FDocuments/' + OneDriveConfig."Destination Folder Name" + '/' + pNewFileName + '_' + pFileName;
                            //pLink := 'https://nexxtspinellc-my.sharepoint.com/personal/bcadmin_nexxtspine_com/Documents/' + OneDriveConfig."Destination Folder Name" + '/' + pNewFileName + ' ' + pFileName;
                            pLink := 'https://nexxtspinellc-my.sharepoint.com/personal/bcadmin_nexxtspine_com/_layouts/15/Doc.aspx?sourcedoc=%2Fpersonal%2Fbcadmin%5Fnexxtspine%5Fcom%2FDocuments%2FBCOneDrive%2FProductionOrderFolder/' + pNewFileName + '.xlsx' + '&file=' + pNewFileName + '.xlsx'; // working
                        end;
                    end;
        end;
    end;
}
