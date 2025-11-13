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
        addafter(Shipment)
        {
            group("NTS ShipTo")
            {
                Caption = 'Ship-To';

                field("NTS Customer Code"; Rec."NTS Customer Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Customer Code field.', Comment = '%';
                }
                field("NTS Ship-to Code"; Rec."NTS Ship-to Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Ship-to Code field.', Comment = '%';
                }
            }
        }
    }
}
