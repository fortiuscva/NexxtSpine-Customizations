pageextension 52116 "NTS Transfer Order Subform" extends "Transfer Order Subform"
{
    layout
    {
        addfirst(Control1)
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
        }
        addlast(Control1)
        {
            field("NTS Set Name"; Rec."NTS Set Name")
            {
                ApplicationArea = All;
                Editable = false;
                ToolTip = 'Specifies the value of the Set Name field.', Comment = '%';
            }
            field("NTS Set Lot No."; Rec."NTS Set Lot No.")
            {
                ApplicationArea = All;
                Editable = false;
                Visible = false;
                ToolTip = 'Specifies the value of the Set Lot No. field.', Comment = '%';
            }
            field("NTS Set Serial No."; Rec."NTS Set Serial No.")
            {
                ApplicationArea = All;
                Editable = false;
                ToolTip = 'Specifies the value of the Set Serial No. field.', Comment = '%';
            }
            field("NTS Surgeon"; Rec."NTS Surgeon")
            {
                ApplicationArea = All;
                Editable = false;
                Visible = false;
                ToolTip = 'Specifies the value of the Surgeon field.', Comment = '%';
            }
            field("NTS Distributor"; Rec."NTS Distributor")
            {
                ApplicationArea = All;
                Editable = false;
                Visible = false;
                ToolTip = 'Specifies the value of the Distributor field.', Comment = '%';
            }
            field("NTS Reps."; Rec."NTS Reps.")
            {
                ApplicationArea = All;
                Editable = false;
                Visible = false;
                ToolTip = 'Specifies the value of the Reps. field.', Comment = '%';
            }
            field("NTS Reps. Name"; Rec."NTS Reps. Name")
            {
                ApplicationArea = All;
                Editable = false;
                Visible = false;
                ToolTip = 'Specifies the value of the Reps. Name field.', Comment = '%';
            }
            field("NTS Sales Order No."; Rec."NTS Sales Order No.")
            {
                ApplicationArea = All;
                Editable = false;
                Visible = false;
                ToolTip = 'Specifies the value of the Sales Order No. field.', Comment = '%';
            }
            field("NTS Sales Order Line No."; Rec."NTS Sales Order Line No.")
            {
                ApplicationArea = All;
                Editable = false;
                Visible = false;
                ToolTip = 'Specifies the value of the Sales Order Line No. field.', Comment = '%';
            }
        }
    }
}
