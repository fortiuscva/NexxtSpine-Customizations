pageextension 52126 "Serial No. Information List" extends "Serial No. Information List"
{
    layout
    {
        addlast(Control1)
        {

            field("NTS Set Type"; Rec."NTS Set Type")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Set Type field.', Comment = '%';
            }
        }
    }
}
