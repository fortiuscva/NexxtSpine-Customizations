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

    var
        NexxtSpineFunctions: Codeunit "NTS NexxtSpine Functions";

}