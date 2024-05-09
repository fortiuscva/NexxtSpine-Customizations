pageextension 52100 "NTS Purchase Order" extends "Purchase Order"
{
    layout
    {
        addafter(Status)
        {
            field("NTS Reason Code"; Rec."NTS Reason Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the reason codes for the Purchase Order and prints them in the report.';
            }
        }
    }
}
