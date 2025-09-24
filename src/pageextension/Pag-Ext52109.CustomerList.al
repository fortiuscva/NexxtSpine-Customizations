pageextension 52109 "Customer List" extends "Customer List"
{
    layout
    {
        addlast(Control1)
        {
            field("Is Distributor"; Rec."NTS Distributor")
            {
                ApplicationArea = All;
                ToolTip = 'Is Distributor';
            }
        }
    }
}
