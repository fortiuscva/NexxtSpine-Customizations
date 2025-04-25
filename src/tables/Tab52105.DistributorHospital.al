table 52105 "NTS Distributor Hospital"
{
    Caption = 'Distributor Hospital';
    DataClassification = AccountData;

    fields
    {
        field(1; "Hospital No."; Code[20])
        {
            Caption = 'Hospital No.';
            TableRelation = Customer."No." where("NTS Is Distributor" = const(false));
        }
    }
    keys
    {
        key(PK; "Hospital No.")
        {
            Clustered = true;
        }
    }
}
