pageextension 52128 "NTS Purchase Order Subform" extends "Purchase Order Subform"
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
