tableextension 52111 "NTS Routing Line" extends "Routing Line"
{
    fields
    {
        field(52100; "NTS IR Sheet 1"; Code[20])
        {
            Caption = 'IR Sheet 1';
            TableRelation = "NTS IR Code";
        }
        field(52101; "NTS IR Sheet 2"; Code[20])
        {
            Caption = 'IR Sheet 2';
            TableRelation = "NTS IR Code";
        }
        field(52102; "NTS IR Sheet 3"; Code[20])
        {
            Caption = 'IR Sheet 3';
            TableRelation = "NTS IR Code";
        }
    }
}