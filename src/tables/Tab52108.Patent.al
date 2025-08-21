table 52108 "NTS Patent"
{
    Caption = 'Patent';

    fields
    {
        field(1; "Code"; Code[25])
        {
            Caption = 'Code';
        }
        field(2; Description; Text[512])
        {
            Caption = 'Description';
        }
    }
    keys
    {
        key(PK; "Code", Description)
        {
            Clustered = true;
        }
    }
}
