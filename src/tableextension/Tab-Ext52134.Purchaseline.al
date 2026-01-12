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
    }
}
