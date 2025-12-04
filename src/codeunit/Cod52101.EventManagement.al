codeunit 52101 "NTS Event Management"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnBeforeSalesInvHeaderInsert', '', false, false)]

    local procedure OnBeforeSalesInvHeaderInsert(var SalesInvHeader: Record "Sales Invoice Header"; var SalesHeader: Record "Sales Header"; CommitIsSuppressed: Boolean; var IsHandled: Boolean; WhseShip: Boolean; WhseShptHeader: Record "Warehouse Shipment Header"; InvtPickPutaway: Boolean)
    begin
        if SalesInvHeader.IsTemporary then
            exit;
        if SalesHeader."Requested Delivery Date" = 0D then
            exit;
        SalesInvHeader."NTS Requested Delivery Date" := SalesHeader."Requested Delivery Date";
    end;

    [EventSubscriber(ObjectType::Codeunit, codeunit::"Gen. Jnl.-Post Line", 'OnPostGLAccOnAfterInitGLEntry', '', false, false)]
    local procedure OnPostGLAccOnAfterInitGLEntry(var GenJournalLine: Record "Gen. Journal Line"; var GLEntry: Record "G/L Entry");
    begin
        if GenJournalLine."Your Reference" = 'ACUUREDSALES' then begin
            GLEntry."NTS Accured Posting Month" := FORMAT(GenJournalLine."Document Date", 0, '<Month Text>');
            GLEntry."NTS Accured Posting Year" := Date2DMY(GenJournalLine."Posting Date", 3);
        end;
        GLEntry."NTS Revenue Reversal" := GenJournalLine."NTS Revenue Reversal";

    end;

    [EventSubscriber(ObjectType::Table, Database::"Prod. Order Routing Line", 'OnAfterCopyFromRoutingLine', '', true, true)]
    local procedure OnAfterCopyFromRoutingLine(var ProdOrderRoutingLine: Record "Prod. Order Routing Line"; RoutingLine: Record "Routing Line")
    var
        IRCode: Record "NTS IR Code";
    begin

        if RoutingLine."NTS IR Sheet 1" <> '' then
            ProdOrderRoutingLine.CopyIRCodesToReferenceIRCodes(RoutingLine."NTS IR Sheet 1");
        if RoutingLine."NTS IR Sheet 2" <> '' then
            ProdOrderRoutingLine.CopyIRCodesToReferenceIRCodes(RoutingLine."NTS IR Sheet 2");

        if RoutingLine."NTS IR Sheet 3" <> '' then
            ProdOrderRoutingLine.CopyIRCodesToReferenceIRCodes(RoutingLine."NTS IR Sheet 3");

        ProdOrderRoutingLine."NTS IR Sheet 1" := RoutingLine."NTS IR Sheet 1";
        ProdOrderRoutingLine."NTS IR Sheet 2" := RoutingLine."NTS IR Sheet 2";
        ProdOrderRoutingLine."NTS IR Sheet 3" := RoutingLine."NTS IR Sheet 3";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Calculate Prod. Order", OnBeforeTransferRouting, '', false, false)]
    local procedure "Calculate Prod. Order_OnBeforeTransferRouting"(var ProdOrder: Record "Production Order"; var ProdOrderLine: Record "Prod. Order Line"; var IsHandled: Boolean)
    var
        NewRecLink: Record "Record Link";
    begin
        NewRecLink.Reset();
        NewRecLink.SetRange("Record ID", ProdOrder.RecordId);
        if NewRecLink.FindSet() then
            NewRecLink.DeleteAll();
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", OnAfterPostSalesLines, '', false, false)]
    local procedure "Sales-Post_OnAfterPostSalesLines"(var SalesHeader: Record "Sales Header"; var SalesShipmentHeader: Record "Sales Shipment Header"; var SalesInvoiceHeader: Record "Sales Invoice Header"; var SalesCrMemoHeader: Record "Sales Cr.Memo Header"; var ReturnReceiptHeader: Record "Return Receipt Header"; WhseShip: Boolean; WhseReceive: Boolean; var SalesLinesProcessed: Boolean; CommitIsSuppressed: Boolean; EverythingInvoiced: Boolean; var TempSalesLineGlobal: Record "Sales Line" temporary)
    begin
        if (SalesShipmentHeader."No." <> '') then
            NexxtSpineFunctions.CreatePositiveAdjustment(SalesHeader);
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"TransferOrder-Post Receipt", OnBeforeTransferOrderPostReceipt, '', false, false)]
    local procedure "TransferOrder-Post Receipt_OnBeforeTransferOrderPostReceipt"(var Sender: Codeunit "TransferOrder-Post Receipt"; var TransferHeader: Record "Transfer Header"; var CommitIsSuppressed: Boolean; var ItemJnlPostLine: Codeunit "Item Jnl.-Post Line")
    begin
        if (TransferHeader."NTS DOR No." <> '') then
            NexxtSpineFunctions.CreateAssemblyOrder(TransferHeader);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Calculate Low-Level Code", OnBeforeCalcLevels, '', false, false)]
    local procedure "Calculate Low-Level Code_OnBeforeCalcLevels"(Type: Option; No: Code[20]; Level: Integer; LevelDepth: Integer; var Result: Integer; var IsHandled: Boolean)
    var
        ItemRec: Record Item;
    begin

        if ItemRec.Get(No) then begin
            if ItemRec."NTS Purchase to Production" then begin
                // Bypass the error and return a safe level
                Result := Level;
                IsHandled := true;
            end;
        end;

    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Calculate Low-Level Code", OnBeforeSetRecursiveLevelsOnBOM, '', false, false)]
    local procedure "Calculate Low-Level Code_OnBeforeSetRecursiveLevelsOnBOM"(var ProductionBOMHeader: Record "Production BOM Header"; LowLevelCode: Integer; IgnoreMissingItemsOrBOMs: Boolean; var IsHandled: Boolean)
    var
        ItemRec: Record Item;
    begin
        if ItemRec.Get(ProductionBOMHeader."No.") then
            if ItemRec."NTS Purchase to Production" then
                IsHandled := true;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Transfer Shipment Line", OnAfterCopyFromTransferLine, '', false, false)]
    local procedure "Transfer Shipment Line_OnAfterCopyFromTransferLine"(var TransferShipmentLine: Record "Transfer Shipment Line"; TransferLine: Record "Transfer Line")
    begin
        TransferShipmentLine."NTS DOR No." := TransferLine."NTS DOR No.";
        TransferShipmentLine."NTS DOR Line No." := TransferLine."NTS DOR Line No.";
        TransferShipmentLine."NTS Surgeon" := TransferLine."NTS Surgeon";
        TransferShipmentLine."NTS Distributor" := TransferLine."NTS Distributor";
        TransferShipmentLine."NTS Reps." := TransferLine."NTS Reps.";
        TransferShipmentLine."NTS Reps. Name" := TransferLine."NTS Reps. Name";
        TransferShipmentLine."NTS Sales Order No." := TransferLine."NTS Sales Order No.";
        TransferShipmentLine."NTS Sales Order Line No." := TransferLine."NTS Sales Order Line No.";
        TransferShipmentLine."NTS Set Name" := TransferLine."NTS Set Name";
        TransferShipmentLine."NTS Set Lot No." := TransferLine."NTS Set Lot No.";
        TransferShipmentLine."NTS Set Serial No." := TransferLine."NTS Set Serial No.";
    end;

    [EventSubscriber(ObjectType::Table, Database::"Transfer Receipt Line", OnAfterCopyFromTransferLine, '', false, false)]
    local procedure "Transfer Receipt Line_OnAfterCopyFromTransferLine"(var TransferReceiptLine: Record "Transfer Receipt Line"; TransferLine: Record "Transfer Line")
    begin
        TransferReceiptLine."NTS DOR No." := TransferLine."NTS DOR No.";
        TransferReceiptLine."NTS DOR Line No." := TransferLine."NTS DOR Line No.";
        TransferReceiptLine."NTS Surgeon" := TransferLine."NTS Surgeon";
        TransferReceiptLine."NTS Distributor" := TransferLine."NTS Distributor";
        TransferReceiptLine."NTS Reps." := TransferLine."NTS Reps.";
        TransferReceiptLine."NTS Reps. Name" := TransferLine."NTS Reps. Name";
        TransferReceiptLine."NTS Sales Order No." := TransferLine."NTS Sales Order No.";
        TransferReceiptLine."NTS Sales Order Line No." := TransferLine."NTS Sales Order Line No.";
        TransferReceiptLine."NTS Set Name" := TransferLine."NTS Set Name";
        TransferReceiptLine."NTS Set Lot No." := TransferLine."NTS Set Lot No.";
        TransferReceiptLine."NTS Set Serial No." := TransferLine."NTS Set Serial No.";
    end;

    [EventSubscriber(ObjectType::Table, Database::"Transfer Shipment Header", OnAfterCopyFromTransferHeader, '', false, false)]
    local procedure "Transfer Shipment Header_OnAfterCopyFromTransferHeader"(var TransferShipmentHeader: Record "Transfer Shipment Header"; TransferHeader: Record "Transfer Header")
    begin
        TransferShipmentHeader."NTS Tracking No." := TransferHeader."NTS Tracking No.";
        TransferShipmentHeader."NTS Tracking URL" := TransferHeader."NTS Tracking URL";
        TransferShipmentHeader."NTS DOR No." := TransferHeader."NTS DOR No.";
        TransferShipmentHeader."NTS Sales Order No." := TransferHeader."NTS Sales Order No.";
        TransferShipmentHeader."NTS Set Name" := TransferHeader."NTS Set Name";
        TransferShipmentHeader."NTS Set Lot No." := TransferHeader."NTS Set Lot No.";
        TransferShipmentHeader."NTS Set Serial No." := TransferHeader."NTS Set Serial No.";
    end;


    [EventSubscriber(ObjectType::Table, Database::"Transfer Receipt Header", OnAfterCopyFromTransferHeader, '', false, false)]
    local procedure "Transfer Receipt Header_OnAfterCopyFromTransferHeader"(var TransferReceiptHeader: Record "Transfer Receipt Header"; TransferHeader: Record "Transfer Header")
    begin
        TransferReceiptHeader."NTS Tracking No." := TransferHeader."NTS Tracking No.";
        TransferReceiptHeader."NTS Tracking URL" := TransferHeader."NTS Tracking URL";
        TransferReceiptHeader."NTS DOR No." := TransferHeader."NTS DOR No.";
        TransferReceiptHeader."NTS Sales Order No." := TransferHeader."NTS Sales Order No.";
        TransferReceiptHeader."NTS Set Name" := TransferHeader."NTS Set Name";
        TransferReceiptHeader."NTS Set Lot No." := TransferHeader."NTS Set Lot No.";
        TransferReceiptHeader."NTS Set Serial No." := TransferHeader."NTS Set Serial No.";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", OnBeforePostSalesLines, '', false, false)]
    local procedure "Sales-Post_OnBeforePostSalesLines"(var SalesHeader: Record "Sales Header"; var TempSalesLineGlobal: Record "Sales Line" temporary; var TempVATAmountLine: Record "VAT Amount Line" temporary; var EverythingInvoiced: Boolean)
    var
        NTSDoRHeader: Record "NTS DoR Header";
    begin
        if SalesHeader.Ship then begin
            if TempSalesLineGlobal.FindSet() then
                repeat
                    if TempSalesLineGlobal."NTS DOR No." <> '' then begin
                        NTSDoRHeader.SetRange("No.", TempSalesLineGlobal."NTS DOR No.");
                        if NTSDoRHeader.FindFirst() then
                            if not NTSDoRHeader.Posted then
                                Error(SalesPostErrorMsg, SalesHeader."No.", NTSDoRHeader."No.");
                    end;
                until TempSalesLineGlobal.Next() = 0;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post", OnBeforeCode, '', false, false)]
    local procedure "Item Jnl.-Post_OnBeforeCode"(var ItemJournalLine: Record "Item Journal Line"; var HideDialog: Boolean; var SuppressCommit: Boolean; var IsHandled: Boolean)
    begin
        if NexxtSingleInstance.GetFromAutoPostItemJnl() then
            HideDialog := true;

    end;

    var
        NexxtSpineFunctions: Codeunit "NTS NexxtSpine Functions";
        SalesPostErrorMsg: Label 'You Cannot post shipment for Sales Order %1.%2 is not posted.';
        NexxtSingleInstance: Codeunit "NTS Single Instance";
}
