pageextension 52129 "Posted Purch. Invoice Subform" extends "Posted Purch. Invoice Subform"
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
