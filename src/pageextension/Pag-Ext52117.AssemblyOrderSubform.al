pageextension 52117 "NTS Assembly Order Subform" extends "Assembly Order Subform"
{
    layout
    {
        addlast(content)
        {
            field("NTS DOR No."; Rec."NTS DOR No.")
            {
                Editable = false;
                ApplicationArea = all;
            }
            field("NTS DOR Line No."; Rec."NTS DOR Line No.")
            {
                Editable = false;
                ApplicationArea = all;
            }
        }
    }
}
