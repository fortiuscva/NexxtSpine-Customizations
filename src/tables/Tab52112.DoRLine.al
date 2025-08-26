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
        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(3; "Item No."; Code[20])
        {
            Caption = 'Item';
            TableRelation = Item."No.";
        }
        field(4; Quantity; Integer)
        {
            Caption = 'Quantity';
        }
        field(5; "Lot Number"; Code[50])
        {
            Caption = 'Lot Number';
            TableRelation = "Lot No. Information"."Lot No." where("Item No." = field("Item No."));
        }
    }
    keys
    {
        key(PK; "DoR Number", "Item No.")
        {
            Clustered = true;
        }
    }
}
