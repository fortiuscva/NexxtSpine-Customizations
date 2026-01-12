tableextension 52137 "NTS Purch.Cr.Memo Line" extends "Purch. Cr. Memo Line"
{
    fields
    {
        field(52100; "NTS Prod. Lot No."; Text[250])
        {
            Caption = 'Production Lot No.';
            DataClassification = CustomerContent;
        }
    }
}
