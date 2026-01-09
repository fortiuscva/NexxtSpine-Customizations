tableextension 52135 "NTS Purch. Inv. Line" extends "Purch. Inv. Line"
{
    fields
    {
        field(52100; "NTS RPO Lot No."; Text[250])
        {
            Caption = 'RPO Lot No.';
            DataClassification = CustomerContent;
        }
    }
}
