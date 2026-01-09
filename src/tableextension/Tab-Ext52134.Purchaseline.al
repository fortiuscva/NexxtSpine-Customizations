tableextension 52134 "NTS Purchase line" extends "Purchase line"
{
    fields
    {
        field(52100; "NTS RPO Lot No."; Text[2048])
        {
            Caption = 'RPO Lot No.';
            DataClassification = CustomerContent;
            Editable = false;
        }
    }
}
