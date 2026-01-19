reportextension 52103 "NTS Assembly Order" extends "Assembly Order"
{
    RDLCLayout = './src/reportextension/Layouts/NTSAssemblyOrder.rdl';
    dataset
    {
        add("Assembly Header")
        {
            column(NTSTracking_AssemblyHeader; GetLotOrSerial())
            {
            }
        }
    }
    labels
    {
        // BOMCaption = 'BOM';
        LotOrSerialCaption = 'LOT/SERIAL#';

    }
    local procedure GetLotOrSerial(): Text[1024]
    var
        ReservEntry: Record "Reservation Entry";
        LotNo: Text;
        SerialNo: Text;

    begin
        Clear(SerialNo);
        Clear(LotNo);
        ReservEntry.Reset();
        ReservEntry.SetRange("Source Type", Database::"Assembly Header");
        ReservEntry.SetRange("Source ID", "Assembly Header"."No.");
        ReservEntry.SetRange("Item No.", "Assembly Header"."Item No.");
        if ReservEntry.FindSet() then
            repeat
                if ReservEntry."Serial No." <> '' then begin
                    if SerialNo = '' then
                        SerialNo := ReservEntry."Serial No."
                    else
                        SerialNo += ',' + ReservEntry."Serial No.";
                end else begin
                    if LotNo = '' then
                        LotNo := ReservEntry."Lot No."
                    else
                        LotNo += ',' + ReservEntry."Lot No.";
                end;

            until ReservEntry.Next() = 0;

        if LotNo <> '' then
            exit(LotNo)
        else
            exit(SerialNo);
    end;

}
