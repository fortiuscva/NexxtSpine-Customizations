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

    [EventSubscriber(ObjectType::Codeunit, codeunit::"Gen. Jnl.-Post Line", 'OnAfterInsertGLEntry', '', false, false)]

    local procedure OnAfterInsertGLEntry(GLEntry: Record "G/L Entry"; GenJnlLine: Record "Gen. Journal Line"; TempGLEntryBuf: Record "G/L Entry" temporary; CalcAddCurrResiduals: Boolean)
    var
        AccureSalesOrderLines: Record "NTS Accrue Sales Order Lines";
        SourceCodeSetup: Record "Source Code Setup";
    begin
        SourceCodeSetup.Get();
        if SourceCodeSetup."NTS Accure Sales Source Code" <> GLEntry."Source Code" then
            exit;
        if AccureSalesOrderLines.Get(GLEntry."Transaction No.") then
            exit;
        AccureSalesOrderLines.Init();
        AccureSalesOrderLines."Entry No." := GLEntry."Transaction No.";
        AccureSalesOrderLines."Document No." := GLEntry."Document No.";
        AccureSalesOrderLines.Amount := GLEntry.Amount;
        AccureSalesOrderLines."Reversal Amount" := GLEntry.Amount;
        AccureSalesOrderLines.Insert();
    end;

    [EventSubscriber(ObjectType::Codeunit, codeunit::"Gen. Jnl.-Post Line", 'OnPostGLAccOnAfterInitGLEntry', '', false, false)]
    local procedure OnPostGLAccOnAfterInitGLEntry(var GenJournalLine: Record "Gen. Journal Line"; var GLEntry: Record "G/L Entry");
    begin
        if GenJournalLine."Journal Batch Name" <> '' then
            GLEntry."Journal Batch Name" := GenJournalLine."Journal Batch Name";
    end;
}
