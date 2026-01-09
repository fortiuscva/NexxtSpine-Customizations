pageextension 52128 "Purchase Order Subform" extends "Purchase Order Subform"
{
    layout
    {
        addfirst(Control1)
        {
            field("NTS RPO Lot No."; Rec."NTS RPO Lot No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the RPO Lot No. field.', Comment = '%';
            }
        }
    }
}
