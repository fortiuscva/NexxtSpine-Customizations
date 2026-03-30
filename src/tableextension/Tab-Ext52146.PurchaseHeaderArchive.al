tableextension 52146 "NTS Purchase Header Archive" extends "Purchase Header Archive"
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
