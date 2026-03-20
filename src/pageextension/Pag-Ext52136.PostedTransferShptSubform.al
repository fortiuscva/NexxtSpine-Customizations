pageextension 52136 "Posted Transfer Shpt. Subform" extends "Posted Transfer Shpt. Subform"
{
    layout
    {
        addlast(Control1)
        {

            field("NTS Backorder"; Rec."NTS Backorder")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Backorder field.', Comment = '%';
            }
        }
    }
}
