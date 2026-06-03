tableextension 52135 "NTS Purch. Inv. Line" extends "Purch. Inv. Line"
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
