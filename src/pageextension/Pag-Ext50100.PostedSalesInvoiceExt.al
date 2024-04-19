pageextension 50100 "NTS Posted Sales Invoice Ext" extends "Posted Sales Invoice"
{
    layout
    {
        addafter("Order No.")
        {
            field("NTS Promised Delivery Date"; Rec."NTS Promised Delivery Date")
            {
                ToolTip = 'Promised Delivery Date';
                ApplicationArea = all;
            }
        }
    }
}
