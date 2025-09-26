table 52109 "NTS Surgeon"
{
    Caption = 'Surgeon';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Code"; Code[10])
        {
            Caption = 'Code';
        }
        field(5; Name; Text[100])
        {
            Caption = 'Name';
        }
    }
    keys
    {
        key(PK; Code)
        {
            Clustered = true;
        }
    }
}
