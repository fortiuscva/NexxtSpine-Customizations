tableextension 52144 "NTS Purch. Rcpt. Header" extends "Purch. Rcpt. Header"
{
    fields
    {
        field(52101; "NTS FOB"; Code[20])
        {
            Caption = 'FOB';
            DataClassification = CustomerContent;
            TableRelation = "NTS FOB";
        }
    }
}
