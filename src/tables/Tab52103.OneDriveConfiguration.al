table 52103 "NTS OneDrive Configuration"
{
    Caption = 'OneDrive Configuration';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Primary Key"; Code[20])
        {
            Caption = 'Primary Key';
        }
        field(2; "Tenant ID"; Text[1024])
        {
            Caption = 'Tenant ID';
        }
        field(3; "Client ID"; Text[1024])
        {
            Caption = 'Client ID';
        }
        field(4; "Client Secret"; Text[1024])
        {
            Caption = 'Client Secret';
        }
        field(5; "OneDrive Tenant ID"; Text[1024])
        {
            Caption = 'OneDrive Tenant ID';
        }
        field(6; "Source Folder Name"; Text[1024])
        {
            Caption = 'Source Folder Name';
        }
        field(7; "Destination Folder Name"; Text[1024])
        {
            Caption = 'Destination Folder Name';
        }
    }
    keys
    {
        key(PK; "Primary Key")
        {
            Clustered = true;
        }
    }
}
