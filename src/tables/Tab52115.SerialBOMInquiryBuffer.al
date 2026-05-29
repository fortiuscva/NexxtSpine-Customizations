table 52115 "NTS Serial BOM Inquiry Buffer"
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Entry No."; Integer)
        { }
        field(2; "Document Type"; Option)
        {
            OptionMembers = "Assembly Consumption","Disassembly Order";
        }
        field(3; "Item No."; Code[20])
        { }
        field(4; Description; Text[100])
        { }
        field(5; Quantity; Decimal)
        { }
        field(6; "Unit of Measure"; Code[10])
        { }
        field(7; "Posting Date"; Date)
        { }
        field(8; "Document No."; Code[20])
        { }
        field(9; "Parent Item No."; Code[20])
        { }
        field(10; "Serial No."; Code[50])
        { }
        field(11; "Lot No."; Code[50])
        { }
        field(12; "Qty Reversed"; Decimal)
        {
            DecimalPlaces = 0 : 5;
        }
        field(13; "Remaining Qty"; Decimal)
        {
            DecimalPlaces = 0 : 5;
        }
        field(14; "Variant Code"; Code[10])
        { }

        field(15; "Location Code"; Code[10])
        { }
    }

    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
    }
}