tableextension 52136 "NTS Purch. Rcpt. Line" extends "Purch. Rcpt. Line"
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
