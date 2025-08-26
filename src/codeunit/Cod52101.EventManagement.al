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

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", OnAfterPostSalesDoc, '', false, false)]
    local procedure "Sales-Post_OnAfterPostSalesDoc"(var SalesHeader: Record "Sales Header"; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line"; SalesShptHdrNo: Code[20]; RetRcpHdrNo: Code[20]; SalesInvHdrNo: Code[20]; SalesCrMemoHdrNo: Code[20]; CommitIsSuppressed: Boolean; InvtPickPutaway: Boolean; var CustLedgerEntry: Record "Cust. Ledger Entry"; WhseShip: Boolean; WhseReceiv: Boolean; PreviewMode: Boolean)
    begin

        if SalesHeader."Document Type" = SalesHeader."Document Type"::Order then
            CreatePositiveAdjustment(SalesHeader);

    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"TransferOrder-Post Transfer", OnAfterTransferOrderPostTransfer, '', false, false)]
    local procedure "TransferOrder-Post Transfer_OnAfterTransferOrderPostTransfer"(var TransferHeader: Record "Transfer Header"; var SuppressCommit: Boolean; var DirectTransHeader: Record "Direct Trans. Header"; InvtPickPutAway: Boolean)
    begin
        CreateAssemblyOrder(TransferHeader);
    end;

    procedure CreatePositiveAdjustment(SalesHeader: Record "Sales Header")
    var
        SalesLine: Record "Sales Line";
        ItemJournalLine: Record "Item Journal Line";
        Location: Record Location;
        FinishedGoodsLocation: Code[10];
        ItemJournalTemplate: Record "Item Journal Template";
        ItemJournalBatch: Record "Item Journal Batch";
        ItemJournalPost: Codeunit "Item Jnl.-Post";
    begin
        // Get Finished Goods Location
        Location.SetRange("NTS Is Finished Goods Location", true);
        if Location.FindFirst() then
            FinishedGoodsLocation := Location."Code";

        // Create journal lines
        SalesLine.SetRange("Document Type", SalesLine."Document Type"::Order);
        SalesLine.SetRange("Document No.", SalesHeader."No.");
        if SalesLine.FindSet() then
            repeat
                ItemJournalLine.Init();
                ItemJournalLine."Journal Template Name" := 'ITEM';
                ItemJournalLine."Journal Batch Name" := 'DEFAULT';
                ItemJournalLine."Line No." := SalesLine."Line No.";
                ItemJournalLine.INSERT(TRUE);
                ItemJournalLine.VALIDATE("Entry Type", ItemJournalLine."Entry Type"::"Positive Adjmt.");
                ItemJournalLine.VALIDATE("Item No.", SalesLine."No.");
                ItemJournalLine.VALIDATE(Quantity, SalesLine.Quantity);
                ItemJournalLine.VALIDATE("Location Code", FinishedGoodsLocation);
                ItemJournalLine.VALIDATE("Unit of Measure Code", SalesLine."Unit of Measure Code");
                ItemJournalLine.Modify(TRUE);
            until SalesLine.Next() = 0;

        // Post the journal
        ItemJournalPost.Run(ItemJournalLine);
    end;

    procedure CreateAssemblyOrder(TransferHeader: Record "Transfer Header")
    var
        AssemblyHeader: Record "Assembly Header";
        AssemblyLine: Record "Assembly Line";
        TransLine: Record "Transfer Line";
    begin
        AssemblyHeader.Init();
        AssemblyHeader."Document Type" := AssemblyHeader."Document Type"::Order;
        AssemblyHeader.Insert(true);
        AssemblyHeader.Validate("Item No.", TransferHeader."NTS Set Name");
        AssemblyHeader.Validate("Posting Date", TransferHeader."Posting Date");
        AssemblyHeader.Validate("Due Date", TransferHeader."Posting Date");
        AssemblyHeader.Validate("Starting Date", TransferHeader."Posting Date");
        AssemblyHeader.Validate("Ending Date", TransferHeader."Posting Date");
        AssemblyHeader.Validate("Location Code", TransferHeader."Transfer-to Code");
        AssemblyHeader.Validate("Shortcut Dimension 1 Code", TransferHeader."Shortcut Dimension 1 Code");
        AssemblyHeader.Validate("Shortcut Dimension 2 Code", TransferHeader."Shortcut Dimension 2 Code");
        AssemblyHeader.Modify(true);

        TransLine.SetRange("Document No.", TransferHeader."No.");
        if TransLine.FindSet() then
            repeat
                AssemblyLine.Init();
                AssemblyLine."Document No." := AssemblyHeader."No.";
                AssemblyLine."Line No." := TransLine."Line No.";
                AssemblyLine.Insert(True);
                AssemblyLine.Validate("No.", TransLine."Item No.");
                AssemblyLine.Validate(Quantity, TransLine.Quantity);
                AssemblyLine.Validate("Unit of Measure Code", TransLine."Unit of Measure");
                AssemblyLine.Modify(true);
            until TransLine.Next() = 0;
    end;
}