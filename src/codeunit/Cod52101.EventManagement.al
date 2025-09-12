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

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", OnAfterPostSalesDoc, '', false, false)]
    local procedure "Sales-Post_OnAfterPostSalesDoc"(var SalesHeader: Record "Sales Header"; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line"; SalesShptHdrNo: Code[20]; RetRcpHdrNo: Code[20]; SalesInvHdrNo: Code[20]; SalesCrMemoHdrNo: Code[20]; CommitIsSuppressed: Boolean; InvtPickPutaway: Boolean; var CustLedgerEntry: Record "Cust. Ledger Entry"; WhseShip: Boolean; WhseReceiv: Boolean; PreviewMode: Boolean)
    begin

        if SalesHeader."Document Type" = SalesHeader."Document Type"::Order then
            NexxtSpineFunctions.CreatePositiveAdjustment(SalesHeader);

    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"TransferOrder-Post Transfer", OnAfterTransferOrderPostTransfer, '', false, false)]
    local procedure "TransferOrder-Post Transfer_OnAfterTransferOrderPostTransfer"(var TransferHeader: Record "Transfer Header"; var SuppressCommit: Boolean; var DirectTransHeader: Record "Direct Trans. Header"; InvtPickPutAway: Boolean)
    begin
        NexxtSpineFunctions.CreateAssemblyOrder(TransferHeader);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Calculate Low-Level Code", OnBeforeCalcLevels, '', false, false)]
    local procedure "Calculate Low-Level Code_OnBeforeCalcLevels"(Type: Option; No: Code[20]; Level: Integer; LevelDepth: Integer; var Result: Integer; var IsHandled: Boolean)
    var
        ItemRec: Record Item;
    begin

        if ItemRec.Get(No) then begin
            if ItemRec."NTS Purchase to Production" and (LevelDepth >= 50) then begin
                // Bypass the error and return a safe level
                Result := Level;
                IsHandled := true;
            end;
        end;

    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Calculate Low-Level Code", OnBeforeCalcLevels, '', false, false)]
    local procedure "Calculate Low-Level Code_OnBeforeCalcLevels"(Type: Option; No: Code[20]; Level: Integer; LevelDepth: Integer; var Result: Integer; var IsHandled: Boolean)
    var
        ItemRec: Record Item;
    begin

        if ItemRec.Get(No) then begin
            if ItemRec."NTS Purchase to Production" and (LevelDepth > 50) then begin
                // Bypass the error and return a safe level
                Result := Level;
                IsHandled := true;
            end;
        end;

    end;

 var
        NexxtSpineFunctions: Codeunit "NTS NexxtSpine Functions";
}