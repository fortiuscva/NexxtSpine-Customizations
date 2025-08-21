pageextension 52111 "NTS Sales Invoice" extends "Sales Invoice"
{
    layout
    {
        addlast(General)
        {
            field("NTS Surgeon"; Rec."NTS Surgeon")
            {
                ApplicationArea = All;
                Caption = 'Surgeon';
            }
            field("NTS Distributor"; Rec."NTS Distributor")
            {
                ApplicationArea = all;
                Caption = 'Distributor';
            }
            field("NTS Rep"; Rec."NTS Reps")
            {
                ApplicationArea = all;
                Caption = 'Reps';
            }
            field("NTS Sales Type"; Rec."NTS Sales Type")
            {
                ApplicationArea = all;
                Caption = 'Sales Type';
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
