pageextension 52113 "NTS Transfer Order" extends "Transfer Order"
{
    layout
    {
        addlast(shipment)
        {
            field("NTS Tracking No."; Rec."NTS Tracking No.")
            {
                ApplicationArea = all;
            }
            field("NTS Tracking URL"; Rec."NTS Tracking URL")
            {
                ApplicationArea = all;
            }
        }
    }
}
