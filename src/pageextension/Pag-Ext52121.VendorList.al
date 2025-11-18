pageextension 52121 "NTS Vendor List" extends "Vendor List"
{
    layout
    {
        addlast(Control1)
        {
            field("NTS Shortcut Dimension 3 Code"; Rec."NTS Shortcut Dimension 3 Code")
            {
                ApplicationArea = All;
                CaptionClass = '1,2,3';
                ToolTip = 'Specifies the value of the Shortcut Dimension 3 Code field.', Comment = '%';
            }
        }
    }
}
