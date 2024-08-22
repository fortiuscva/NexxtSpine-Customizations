pageextension 52105 "NTS Prod. Order Routing" extends "Prod. Order Routing"
{
    layout
    {
        addafter("Move Time")
        {
            field("NTS IR Sheet 1"; Rec."NTS IR Sheet 1")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the NTS IR Sheet 1 field.';
            }
            field("NTS IR Sheet 2"; Rec."NTS IR Sheet 2")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the NTS IR Sheet 2 field.';
            }
            field("NTS IR Sheet 3"; Rec."NTS IR Sheet 3")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the NTS IR Sheet 3 field.';
            }
        }
    }
}