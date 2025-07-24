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
        }
    }
}
