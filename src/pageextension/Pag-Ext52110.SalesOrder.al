pageextension 52110 "NTS Sales Order" extends "Sales Order"
{
    layout
    {
        addlast(General)
        {
            group("NTS DORDetails")
            {
                Caption = 'Deliver of Record';
                Visible = false;

                field("NTS DoR Number"; Rec."NTS DOR No.")
                {
                    ApplicationArea = all;
                    Editable = false;
                    Caption = 'DOR No.';
                }
                field("NTS Surgeon"; Rec."NTS Surgeon")
                {
                    ApplicationArea = All;
                    Caption = 'Surgeon';
                    Editable = false;
                }
                field("NTS Distributor"; Rec."NTS Distributor")
                {
                    ApplicationArea = all;
                    Caption = 'Distributor';
                    Editable = false;
                }
                field("NTS Reps"; Rec."NTS Reps.")
                {
                    ApplicationArea = all;
                    Caption = 'Reps';
                    Editable = false;
                }
            }
        }
    }
    actions
    {
        addlast(processing)
        {
            group("NTS NexxtSpine")
            {
                Caption = 'Nexxt Spint';
                action("NTS CreateTransferOrder")
                {
                    Caption = 'Create Transfer Order';
                    Image = NewTransferOrder;
                    ApplicationArea = All;
                    Promoted = true;
                    PromotedIsBig = true;
                    PromotedCategory = Process;
                    trigger OnAction()
                    var
                        NTSFunctions: Codeunit "NTS NexxtSpine Functions";
                        TransferHeader: Record "Transfer Header";
                        TOCreatedError: Label 'Transfer Order was already Created for this Sales Order %1';
                    begin
                        if Rec."NTS Transfer Order Created" then
                            Error(StrSubstNo(TOCreatedError, Rec."No."));
                        Rec.TestField(Status, Rec.Status::Released);
                        if not Confirm('Do you want to Create Transfer Order?') then
                            exit;
                        NTSFunctions.CreateTransferOrder(Rec);
                    end;
                }
                action("NTS OpenTransferOrder")
                {
                    Caption = 'Show Transfer Order';
                    Image = TransferOrder;
                    ApplicationArea = All;
                    Promoted = true;
                    trigger OnAction()
                    var
                        TransferHeader: Record "Transfer Header";
                    begin
                        TransferHeader.SetRange("NTS DOR No.", Rec."NTS DOR No.");
                        if TransferHeader.FindFirst() then
                            Page.RunModal(Page::"Transfer Order", TransferHeader);
                    end;
                }
            }
        }
    }
}
