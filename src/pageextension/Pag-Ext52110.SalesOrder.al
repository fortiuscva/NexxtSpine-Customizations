pageextension 52110 "NTS Sales Order" extends "Sales Order"
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
            field("NTS Reps"; Rec."NTS Reps")
            {
                ApplicationArea = all;
                Caption = 'Reps';
            }
        }
    }
}
