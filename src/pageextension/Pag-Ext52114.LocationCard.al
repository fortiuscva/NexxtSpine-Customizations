pageextension 52114 "NTS Location Card" extends "Location Card"
{
    layout
    {
        addlast(General)
        {
            field("NTS Is Finished Goods Location"; Rec."NTS Is Finished Goods Location")
            {
                ApplicationArea = all;
                Caption = 'Is Finished Goods Location';
            }
        }
    }
}
