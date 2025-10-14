table 52109 "NTS Surgeon"
{
    Caption = 'Surgeon';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Code"; Code[100])
        {
            Caption = 'Code';
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
