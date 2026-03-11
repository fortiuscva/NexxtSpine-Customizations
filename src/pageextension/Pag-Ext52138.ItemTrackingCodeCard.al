pageextension 52138 "NTS Item Tracking Code Card" extends "Item Tracking Code Card"
{
    layout
    {
        addlast(Control74)
        {
            field("NTS Add Revision"; Rec."NTS Add Revision")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Add Revision field.', Comment = '%';
            }
        }
    }
}
