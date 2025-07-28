pageextension 52114 "NTS Location Card" extends "Location Card"
{
    layout
    {
        addlast(General)
        {
            field("NTS Finished Goods Location"; Rec."NTS Finished Goods Location")
            {
                ApplicationArea = all;
                Caption = 'Finished Goods Location';
            }
        }
    }
}
