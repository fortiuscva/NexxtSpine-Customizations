table 52112 "NTS DoR Line"
{
    Caption = 'DoR Line';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "DoR Number"; Code[20])
        {
            Caption = 'DoR Number';
            TableRelation = "NTS DoR Header"."DoR Number";
        }
        field(2; Item; Code[20])
        {
            Caption = 'Item';
            TableRelation = Item."No.";
        }
        field(3; Quantity; Integer)
        {
            Caption = 'Quantity';
        }
        field(4; "Lot Number"; Code[50])
        {
            Caption = 'Lot Number';
        }
    }
    keys
    {
        key(PK; "DoR Number")
        {
            Clustered = true;
        }
    }
}
