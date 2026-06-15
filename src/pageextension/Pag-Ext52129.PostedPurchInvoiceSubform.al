pageextension 52129 "Posted Purch. Invoice Subform" extends "Posted Purch. Invoice Subform"
{
    layout
    {
        addafter(Quantity)
        {
            field("NTS RPO Lot No."; Rec."NTS Prod. Lot No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the RPO Lot No. field.', Comment = '%';
            }
        }
        addafter(Description)
        {
            field("NTS GTIN"; Rec."NTS GTIN")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the GTIN field.';
            }
        }
    }
}
