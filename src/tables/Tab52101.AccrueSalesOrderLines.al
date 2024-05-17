table 52101 "NTS Accrue Sales Order Lines"
{
    Caption = 'Accrue Sales Order Lines';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
        }
        field(2; "Document No."; Code[20])
        {
            Caption = 'Document No.';
        }
        field(3; "Date"; Date)
        {
            Caption = 'Date';
        }
        field(4; Amount; Decimal)
        {
            Caption = 'Amount';
        }
        field(5; "Reversal Amount"; Decimal)
        {
            Caption = 'Reversal Amount';
        }
        field(6; "Entry Type"; Code[20])
        {
            Caption = 'Entry Type';
        }
        field(7; Status; Code[20])
        {
            Caption = 'Status';
        }
        field(8; "Error Text"; text[1024])
        {
            Caption = 'Error Text';
        }
    }
    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
    }
}
