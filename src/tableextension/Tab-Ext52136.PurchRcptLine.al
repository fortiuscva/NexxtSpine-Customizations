tableextension 52136 "NTS Purch. Rcpt. Line" extends "Purch. Rcpt. Line"
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
