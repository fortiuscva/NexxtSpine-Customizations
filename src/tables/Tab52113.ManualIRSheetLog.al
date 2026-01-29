table 52113 "NTS Manual IR Sheet Log"
{
    DataClassification = ToBeClassified;
    Caption = 'Manual IR Sheet Log';

    fields
    {
        field(1; "Entry No."; Integer)
        {
            AutoIncrement = true;
        }
        field(2; "Source Type"; Integer) { }
        field(3; "Source Subtype"; Enum "Production Order Status") { }
        field(4; "Source No."; Code[20]) { }
        field(5; "Source Line No."; Integer) { }
        field(6; "Operation No."; Code[10]) { }
        field(7; "IR Code"; Code[20]) { }
        field(8; "Entered By"; Code[50]) { }
        field(9; "Entered On"; DateTime) { }
    }

    keys
    {
        key(PK; "Entry No.") { Clustered = true; }
    }
}
