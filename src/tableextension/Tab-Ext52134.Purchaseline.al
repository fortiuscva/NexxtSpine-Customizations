tableextension 52134 "NTS Purchase line" extends "Purchase line"
{
    fields
    {
        field(52100; "NTS Prod. Lot No."; Text[250])
        {
            Caption = 'Production Lot No.';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(52101; "NTS GTIN"; Code[14])
        {
            Caption = 'GTIN';
            Numeric = true;
            ExtendedDatatype = Barcode;
            Editable = false;
        }
    }
}
