pageextension 52111 "NTS Sales Invoice" extends "Sales Invoice"
{
    layout
    {
        addlast(General)
        {
            group("NTS DORDetails")
            {
                Caption = 'Deliver of Record';
                // Visible = false;
                field("NTS Surgeon"; Rec."NTS Surgeon")
                {
                    ApplicationArea = All;
                    Caption = 'Surgeon';
                }
                field("NTS Surgeon Name"; Rec."NTS Surgeon Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Surgeon Name field.', Comment = '%';
                }
                field("NTS Distributor"; Rec."NTS Distributor")
                {
                    ApplicationArea = all;
                    Caption = 'Distributor';
                }
                field("NTS Distributor Name"; Rec."NTS Distributor Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Distributor Name field.', Comment = '%';
                }
                field("NTS Rep"; Rec."NTS Reps.")
                {
                    ApplicationArea = all;
                    Caption = 'Reps';
                }
                field("NTS Sales Type"; Rec."NTS Sales Type")
                {
                    ApplicationArea = all;
                    Caption = 'Sales Type';
                    Visible = false;
                }
            }
        }
        modify("Shortcut Dimension 1 Code")
        {
            Visible = false;
        }
        modify("Shortcut Dimension 2 Code")
        {
            Visible = false;
        }

    }
}
