tableextension 52143 "NTS Purch. Inv. Header" extends "Purch. Inv. Header"
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
