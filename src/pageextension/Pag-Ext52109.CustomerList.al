pageextension 52109 "NTS Customer List" extends "Customer List"
{
    layout
    {
        addlast(Control1)
        {
            field("NTS Is Distributor"; Rec."NTS Distributor")
            {
                ApplicationArea = All;
                ToolTip = 'Is Distributor';
            }
            field("NTS Shortcut Dimension 3"; Rec."NTS Shortcut Dimension 3 Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Shortcut Dimension 3 Code field.', Comment = '%';
            }
        }
    }
}

