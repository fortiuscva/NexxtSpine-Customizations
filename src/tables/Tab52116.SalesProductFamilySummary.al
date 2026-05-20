table 52116 "Sales Product Family Summary"
{
    Caption = 'Sales Product Family Summary';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Document No."; Code[20])
        {
            Caption = 'Document No.';
            DataClassification = CustomerContent;
        }
        field(2; "Family 1"; Code[50])
        {
            Caption = 'Family 1';
            DataClassification = CustomerContent;
        }
        field(3; "Amount 1"; Decimal)
        {
            Caption = 'Amount 1';
            DataClassification = CustomerContent;
        }
        field(4; "Family 2"; Code[50])
        {
            Caption = 'Family 2';
            DataClassification = CustomerContent;
        }
        field(5; "Amount 2"; Decimal)
        {
            Caption = 'Amount 2';
            DataClassification = CustomerContent;
        }
        field(6; "Family 3"; Code[50])
        {
            Caption = 'Family 3';
            DataClassification = CustomerContent;
        }
        field(7; "Amount 3"; Decimal)
        {
            Caption = 'Amount 3';
            DataClassification = CustomerContent;
        }
        field(8; "Family 4"; Code[50])
        {
            Caption = 'Family 4';
            DataClassification = CustomerContent;
        }
        field(9; "Amount 4"; Decimal)
        {
            Caption = 'Amount 4';
            DataClassification = CustomerContent;
        }
        field(10; "Document Type"; Enum "Sales Document Type")
        {
            DataClassification = CustomerContent;
            Caption = 'Document Type';
        }
    }
    keys
    {
        key(PK; "Document No.")
        {
            Clustered = true;
        }
    }
}
