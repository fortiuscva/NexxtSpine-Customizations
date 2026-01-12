pageextension 52130 "Posted Purchase Rcpt. Subform" extends "Posted Purchase Rcpt. Subform"
{
    layout
    {
        addfirst(Control1)
        {
            field("NTS RPO Lot No."; Rec."NTS Prod. Lot No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the RPO Lot No. field.', Comment = '%';
            }
        }
    }
}
