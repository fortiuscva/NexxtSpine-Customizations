pageextension 52108 "NTS Customer Card" extends "Customer Card"
{
    layout
    {
        addlast(General)
        {
            field("NTS Is Distributor"; Rec."NTS Distributor")
            {
                ApplicationArea = All;
            }
        }
    }
}
