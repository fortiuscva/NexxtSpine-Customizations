pageextension 52103 "NTS Posted Sales Invoice Ext" extends "Posted Sales Invoice"
{
    layout
    {
        addafter("Order No.")
        {
            field("NTS Requested Delivery Date"; Rec."NTS Requested Delivery Date")
            {
                ToolTip = 'Requested Delivery Date';
                ApplicationArea = all;
            }
        }
    }
}
