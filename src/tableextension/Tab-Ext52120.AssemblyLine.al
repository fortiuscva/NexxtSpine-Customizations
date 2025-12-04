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
        field(52132; "NTS Item Tracking Lines"; Boolean)
        {
            Caption = 'Item Tracking Lines';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = exist("Reservation Entry" where("Source ID" = field("Document No."), "Source Ref. No." = field("Line No."), "Source Type" = const(901), "Source Subtype" = field("Document Type"), "Reservation Status" = filter(Surplus)));
        }
    }
}
