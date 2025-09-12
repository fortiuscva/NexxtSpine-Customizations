tableextension 52120 "NTS Assembly Line" extends "Assembly Line"
{
    fields
    {
        field(52100; "NTS DOR No."; Code[20])
        {
            Caption = 'DOR No.';
            DataClassification = CustomerContent;
        }
        field(52101; "NTS DOR Line No."; Integer)
        {
            Caption = 'DOR Line No.';
            DataClassification = CustomerContent;
        }
    }
}
