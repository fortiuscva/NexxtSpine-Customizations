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
        addlast("F&unctions")
        {
            action("NTS CreateTransferOrder")
            {
                Caption = 'Create Transfer';
                Image = Create;
                ApplicationArea = All;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                trigger OnAction()
                var
                    NTSFunctions: Codeunit "NTS NexxtSpine Functions";
                begin
                    if not Confirm('Do you want to Create Transfer Order?') then
                        exit;
                    NTSFunctions.CreateTransferOrder(Rec);
                end;
            }
        }
    }
}
