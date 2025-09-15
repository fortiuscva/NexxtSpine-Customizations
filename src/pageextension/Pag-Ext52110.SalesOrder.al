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
        addfirst(processing)
        {
            group("NTS NEXXTSPINE")
            {
                Caption = 'NEXXTSPINE';
                action("NTS CreateTransferOrder")
                {
                    Caption = 'Create Transfer Order';
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

        addlast(navigation)
        {
            action("NTS Transfer Order")
            {
                Caption = 'Open Transfer Order';
                Image = Open;
                ApplicationArea = All;
                trigger OnAction()
                var
                    TransferHeader: Record "Transfer Header";
                begin
                    TransferHeader.SetRange("NTS DOR No.", Rec."NTS DoR Number");
                    if TransferHeader.FindFirst() then
                        Page.RunModal(Page::"Transfer Order", TransferHeader);
                end;
            }
        }
    }
}
