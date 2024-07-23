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
        case true of
            RoutingLine."NTS IR Sheet 1" <> '':
                begin
                    ProdOrderRoutingLine.CopyIRCodesToReferenceIRCodes(RoutingLine."NTS IR Sheet 1");
                end;
            RoutingLine."NTS IR Sheet 2" <> '':
                begin
                    ProdOrderRoutingLine.CopyIRCodesToReferenceIRCodes(RoutingLine."NTS IR Sheet 2");
                end;
            RoutingLine."NTS IR Sheet 3" <> '':
                begin
                    ProdOrderRoutingLine.CopyIRCodesToReferenceIRCodes(RoutingLine."NTS IR Sheet 3");
                end;
        end;

        ProdOrderRoutingLine."NTS IR Sheet 1" := RoutingLine."NTS IR Sheet 1";
        ProdOrderRoutingLine."NTS IR Sheet 2" := RoutingLine."NTS IR Sheet 2";
        ProdOrderRoutingLine."NTS IR Sheet 3" := RoutingLine."NTS IR Sheet 3";
    end;
}