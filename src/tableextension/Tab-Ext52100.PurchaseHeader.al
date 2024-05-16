tableextension 52100 "NTS Purchase Header" extends "Purchase Header"
{
    fields
    {
        field(52100; "NTS Reason Code"; Code[50])
        {
            Caption = 'Reason Code';
            DataClassification = CustomerContent;
            TableRelation = "NTS Purchase Reason Code";
        }
    }
}
