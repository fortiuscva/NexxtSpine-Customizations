pageextension 52145 "Posted Assembly Order Subform" extends "Posted Assembly Order Subform"
{
    layout
    {
        addafter(Quantity)
        {
            field("NTS Qty Reversed"; Rec."NTS Qty Reversed")
            {
                ApplicationArea = All;
                Visible = false;
            }
        }
    }
}
