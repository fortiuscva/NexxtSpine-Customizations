table 52109 "NTS Surgeon"
{
    Caption = 'Surgeon';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Surgeon Name"; Text[100])
        {
            Caption = 'Surgeon Name';
        }
    }
    keys
    {
        key(PK; "Surgeon Name")
        {
            Clustered = true;
        }
    }
}
