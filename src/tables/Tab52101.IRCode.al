table 52101 "NTS IR Code"
{
    Caption = 'IR Code';
    DataClassification = CustomerContent;
    LookupPageId = "NTS IR Codes";
    DrillDownPageId = "NTS IR Codes";

    fields
    {
        field(1; "Code"; Code[100])
        {
            Caption = 'Code';
        }
        field(2; "IR Number"; Code[20])
        {
            Caption = 'IR Number';
        }
        field(3; "IR Sheet Name"; Text[80])
        {
            Caption = 'IR Sheet Name';
        }
        field(4; Link; Text[2048])
        {
            Caption = 'Link';
        }
    }

    keys
    {
        key(Key1; Code)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}