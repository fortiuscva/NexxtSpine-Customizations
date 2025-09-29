pageextension 52116 "NTS Transfer Order Subform" extends "Transfer Order Subform"
{
    layout
    {
        addlast(Control1)
        {
            field("NTS DOR No."; Rec."NTS DOR No.")
            {
                Editable = false;
                ApplicationArea = all;
            }
            field("NTS DOR Line No."; Rec."NTS DOR Line No.")
            {
                Editable = false;
                ApplicationArea = all;
            }
            field("NTS Set Name"; Rec."NTS Set Name")
            {
                Editable = false;
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Set Name field.', Comment = '%';
            }
        }
    }
}
