pageextension 52115 "NTS Sales Order Subform" extends "Sales Order Subform"
{
    layout
    {
        addfirst(Control1)
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
