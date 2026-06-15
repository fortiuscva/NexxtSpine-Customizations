tableextension 52138 "NTS Purchase Line Archive" extends "Purchase Line Archive"
{
    fields
    {
        field(52100; "NTS Prod. Lot No."; Text[250])
        {
            Caption = 'Production Lot No.';
            DataClassification = CustomerContent;
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
