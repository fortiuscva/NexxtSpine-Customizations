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
            field("NTS DoR Number"; Rec."NTS DoR Number")
            {
                ApplicationArea = all;
                Caption = 'DoR Number';
            }
        }
    }
    actions
    {
        addlast(Processing)
        {
            action("NTS CreateTransferOrder")
            {
                Caption = 'Create Transfer';
                Image = Create;
                ApplicationArea = All;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                RunObject = report "NTS Create TO from SO";
            }
        }
    }
}
