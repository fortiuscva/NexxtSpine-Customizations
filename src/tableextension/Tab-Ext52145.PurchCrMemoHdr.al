tableextension 52145 "NTS Purch. Cr. Memo Hdr." extends "Purch. Cr. Memo Hdr."
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
