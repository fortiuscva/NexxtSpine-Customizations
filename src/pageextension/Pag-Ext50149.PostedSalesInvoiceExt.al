pageextension 50149 "NTS Posted Sales Invoice Ext" extends "Posted Sales Invoice"
{
    layout
    {
        addafter("Order No.")
        {
            field("NTS Promised Delivery Date"; Rec."NTS Requested Delivery Date")
            {
                ToolTip = 'Requested Delivery Date';
                ApplicationArea = all;
            }
        }
    }
}
