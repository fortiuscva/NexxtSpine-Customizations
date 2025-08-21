table 52107 "NTS Item Availability Snapshot"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Item No."; Code[20]) { DataClassification = CustomerContent; }
        field(2; "Location Code"; Code[10]) { DataClassification = CustomerContent; }
        field(3; "Supply Qty"; Decimal) { DataClassification = CustomerContent; }
        field(4; "Demand Qty"; Decimal) { DataClassification = CustomerContent; }
        field(5; "Available Qty"; Decimal) { DataClassification = CustomerContent; }
        field(6; "Last Updated"; DateTime) { DataClassification = CustomerContent; }
    }

    keys
    {
        key(PK; "Item No.", "Location Code") { Clustered = true; }
    }
}
