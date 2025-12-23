reportextension 52102 "NTS Posted Assembly Order" extends "Posted Assembly Order"
{
    RDLCLayout = './src/reportextension/Layouts/PostedAssemblyOrder.rdlc';
    dataset
    {
        add("Posted Assembly Line")
        {
            column(NTSTracking_PostedAssemblyLine; GetLotOrSerial())
            {
            }
        }
    }
    labels
    {
        BOMCaption = 'BOM';
        LotOrSerialCaption = 'LOT/SERIAL#';

    }
    local procedure GetLotOrSerial(): Text[1024]
    var
        ItemLedgerEntry: Record "Item Ledger Entry";
        LotNo: Text;
        SerialNo: Text;

    begin
        Clear(SerialNo);
        Clear(LotNo);
        ItemLedgerEntry.Reset();
        ItemLedgerEntry.SetRange("Document No.", "Posted Assembly Line"."Document No.");
        ItemLedgerEntry.SetRange("Document Line No.", "Posted Assembly Line"."Line No.");
        ItemLedgerEntry.SetRange("Item No.", "Posted Assembly Line"."No.");

        if ItemLedgerEntry.FindSet() then
            repeat
                if ItemLedgerEntry."Serial No." <> '' then begin
                    if SerialNo = '' then
                        SerialNo := ItemLedgerEntry."Serial No."
                    else
                        SerialNo += ',' + ItemLedgerEntry."Serial No.";
                end else begin
                    if LotNo = '' then
                        LotNo := ItemLedgerEntry."Lot No."
                    else
                        LotNo += ',' + ItemLedgerEntry."Lot No.";
                end;

            until ItemLedgerEntry.Next() = 0;

        if LotNo <> '' then
            exit(LotNo)
        else
            exit(SerialNo);
    end;

}
