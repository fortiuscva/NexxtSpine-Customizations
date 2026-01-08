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
            group("NTS Transfer Order Details")
            {
                Caption = 'Transfer Order Details';
                field("NTS No. of Transfer Orders"; Rec."NTS No. of Transfer Orders")
                {

                    ApplicationArea = All;
                    Editable = false;
                    DrillDown = true;

                    trigger OnDrillDown()
                    var
                        TransferHeader: Record "Transfer Header";
                    begin
                        TransferHeader.Reset();
                        TransferHeader.SetRange("NTS Sales Order No.", Rec."No.");
                        PAGE.RunModal(PAGE::"Transfer Orders", TransferHeader);
                    end;
                }

                field("NTS No. of Posted Transfer Shipments"; Rec."NTS No. of Posted Trans. Shpt.")
                {
                    ApplicationArea = All;
                    Editable = false;
                    DrillDown = true;

                    trigger OnDrillDown()
                    var
                        TransferShptHdr: Record "Transfer Shipment Header";
                    begin
                        TransferShptHdr.Reset();
                        TransferShptHdr.SetRange("NTS Sales Order No.", Rec."No.");
                        PAGE.RunModal(PAGE::"Posted Transfer Shipments", TransferShptHdr);
                    end;
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
                        //NTSFunctions.CreateTransferOrder(Rec);
                        NTSFunctions.CreateTransferOrderforMultipleDoRs(Rec);
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
                        TransferHeader.SetRange("NTS Sales Order No.", Rec."No.");
                        Page.RunModal(Page::"Transfer Orders", TransferHeader);
                    end;
                }
            }
        }
    }
}
