page 52121 "NTS Posted DOR"
{
    ApplicationArea = All;
    Caption = 'Posted DOR';
    PageType = Document;
    Editable = false;
    SourceTable = "NTS DOR Header";
    UsageCategory = None;
    SourceTableView = where(Posted = const(true));
    DataCaptionFields = "No.", "Customer Name";

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the number of the involved entry or record, according to the specified number series.';
                }
                field(Customer; Rec."Customer No.")
                {
                    ToolTip = 'Specifies the value of the Customer field.', Comment = '%';
                }
                field("Customer Name"; Rec."Customer Name")
                {
                    ToolTip = 'Specifies the value of the Customer Name field.', Comment = '%';
                }

                field("Set Name"; Rec."Set Name")
                {
                    ToolTip = 'Specifies the value of the Set Name field.', Comment = '%';
                }
                field("Set Description"; Rec."Set Description")
                {
                    ToolTip = 'Specifies the value of the Set Description field.', Comment = '%';
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ToolTip = 'Specifies the value of the Posting Date field.', Comment = '%';
                }
                field(Status; Rec.Status)
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Status field.', Comment = '%';
                }

                group(ItemTracking)
                {
                    Caption = 'Item Tracking';
                    field("Lot No."; Rec."Lot No.")
                    {
                        ToolTip = 'Specifies the value of the Lot No. field.', Comment = '%';
                    }
                    field("Serial Number"; Rec."Serial No.")
                    {
                        ToolTip = 'Specifies the value of the Serial Number field.', Comment = '%';
                    }
                    field(Quantity; Rec.Quantity)
                    {
                        ToolTip = 'Specifies the value of the Quantity field.', Comment = '%';
                    }
                }
                group(Surgery)
                {
                    Caption = 'Surgery';
                    field(Surgeon; Rec.Surgeon)
                    {
                        ToolTip = 'Specifies the value of the Surgeon field.', Comment = '%';
                    }
                    field("Surgery Date"; Rec."Surgery Date")
                    {
                        ToolTip = 'Specifies the value of the Surgery Date field.', Comment = '%';
                    }
                    field(Reps; Rec."Reps.")
                    {
                        ToolTip = 'Specifies the value of the Reps field.', Comment = '%';
                    }
                    field("Reps. Name"; Rec."Reps. Name")
                    {
                        ToolTip = 'Specifies the value of the Reps. Name field.', Comment = '%';
                    }
                    field(Distributor; Rec.Distributor)
                    {
                        ToolTip = 'Specifies the value of the Distributor field.', Comment = '%';
                    }
                    field("Location Code"; Rec."Location Code")
                    {
                        Editable = false;
                        ToolTip = 'Specifies the value of the Location Code field.', Comment = '%';
                    }
                }
            }
            part(PostedDoRLinesPart; "NTS Posted DOR Subform")
            {
                ApplicationArea = All;
                SubPageLink = "Document No." = field("No.");
            }
            part(DORNonConsumedItems; "NTS DOR Non-Consumed Items SF")
            {
                ApplicationArea = All;
                SubPageLink = "Document No." = field("No.");
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action("NTS Re-create Sales Order")
            {
                Caption = 'Re-create Sales Order';
                ApplicationArea = all;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = Redo;
                trigger OnAction()
                var
                    SalesOrderAlreadyCreatedVarLcl: Boolean;
                begin
                    clear(SalesOrderAlreadyCreatedVarLcl);
                    Rec.TestField("Customer No.");

                    SalesHeader.Reset();
                    SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::Order);
                    SalesHeader.SetRange("NTS DOR No.", Rec."No.");
                    SalesOrderAlreadyCreatedVarLcl := SalesHeader.FindFirst();

                    if not SalesOrderAlreadyCreatedVarLcl then begin
                        SalesShptHeader.Reset();
                        SalesShptHeader.SetRange("NTS DOR No.", Rec."No.");
                        SalesOrderAlreadyCreatedVarLcl := SalesShptHeader.FindFirst();
                    end;
                    if not SalesOrderAlreadyCreatedVarLcl then begin
                        SalesInvHeader.Reset();
                        SalesInvHeader.SetRange("NTS DOR No.", Rec."No.");
                        SalesOrderAlreadyCreatedVarLcl := SalesInvHeader.FindFirst();
                    end;
                    if SalesOrderAlreadyCreatedVarLcl then begin
                        if Confirm(StrSubstNo(SalesDocumentAlreadyExistsandProceedMsg, Rec."No."), false) then
                            NexxSpineFunctions.CreateSalesOrder(Rec, false);
                    end else
                        if Confirm(StrSubstNo(RecreateOrderProceedMsg, Rec."No.")) then
                            NexxSpineFunctions.CreateSalesOrder(Rec, false);
                end;
            }

            group(Sales)
            {
                Caption = 'Sales';
                action("NTS Sales Order")
                {
                    Caption = 'Order';
                    ApplicationArea = all;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    Image = Order;
                    trigger OnAction()
                    var
                        SalesHeader: Record "Sales Header";
                    begin
                        SalesHeader.Reset();
                        SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::Order);
                        SalesHeader.SetRange("NTS DOR No.", Rec."No.");
                        if SalesHeader.FindFirst() then
                            Page.RunModal(Page::"Sales Order List", SalesHeader);
                    end;
                }
                action("NTS Shipments")
                {
                    Caption = 'Shipments';
                    ApplicationArea = all;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    Image = Shipment;
                    trigger OnAction()
                    begin
                        SalesShptHeader.Reset();
                        SalesShptHeader.SetRange("NTS DOR No.", Rec."No.");
                        if SalesShptHeader.FindFirst() then
                            Page.RunModal(Page::"Posted Sales Shipments", SalesShptHeader);
                    end;
                }
                action("NTS Invoices")
                {
                    Caption = 'Invoices';
                    ApplicationArea = all;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    Image = Invoice;
                    trigger OnAction()
                    begin
                        SalesInvHeader.Reset();
                        SalesInvHeader.SetRange("NTS DOR No.", Rec."No.");
                        if SalesInvHeader.FindFirst() then
                            Page.RunModal(Page::"Posted Sales Invoices", SalesInvHeader);
                    end;
                }
            }
        }
    }

    var

        SalesHeader: Record "Sales Header";
        SalesShptHeader: Record "Sales Shipment Header";
        SalesInvHeader: Record "Sales Invoice Header";
        NexxSpineFunctions: Codeunit "NTS NexxtSpine Functions";
        SalesDocumentAlreadyExistsandProceedMsg: Label 'Sales order or posted documents already exists for %1, Do you want to re-create sales order?';
        RecreateOrderProceedMsg: Label 'Do you want to re-create sales order?';
}
