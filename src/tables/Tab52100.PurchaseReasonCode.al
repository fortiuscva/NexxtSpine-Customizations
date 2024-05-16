table 52100 "NTS Purchase Reason Code"
{
    Caption = 'Purchase Reason Code';
    DataClassification = CustomerContent;
    DataPerCompany = false;
    LookupPageId = "NTS Purchase Reason Codes";
    DrillDownPageId = "NTS Purchase Reason Codes";

    fields
    {
        field(1; "Code"; Code[50])
        {
            Caption = 'Code';
            DataClassification = CustomerContent;
        }
        field(2; Description; Text[1024])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
    }
    keys
    {
        key(PK; "Code")
        {
            Clustered = true;
        }
    }
}
