tableextension 52121 "NTS Assembly Header" extends "Assembly Header"
{
    fields
    {
        field(52100; "NTS DOR No."; Code[20])
        {
            Caption = 'NTS DOR No.';
            DataClassification = CustomerContent;
        }
        field(52132; "NTS Item Tracking Lines"; Boolean)
        {
            Caption = 'Item Tracking Lines';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = exist("Reservation Entry" where("Source ID" = field("No."), "Source Ref. No." = const(0), "Source Type" = const(900), "Source Subtype" = field("Document Type"), "Reservation Status" = filter(Surplus)));
        }

    }
}
