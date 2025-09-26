table 52104 "NTS Distributor Location"
{
    Caption = 'Distributor Location';
    DataClassification = AccountData;

    fields
    {
        field(1; "Distributor No."; Code[20])
        {
            Caption = 'Distributor ID';
            TableRelation = Customer."No." where("NTS Distributor" = const(true));
        }
        field(2; "Location Code"; Code[10])
        {
            Caption = 'Location Code';
            TableRelation = Location.Code;
        }
        field(3; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            TableRelation = Item."No.";
        }
        field(4; Quantity; Decimal)
        {
            Caption = 'Quantity';
        }
    }
    keys
    {
        key(PK; "Distributor No.", "Location Code", "Item No.")
        {
            Clustered = true;
        }
    }
}
