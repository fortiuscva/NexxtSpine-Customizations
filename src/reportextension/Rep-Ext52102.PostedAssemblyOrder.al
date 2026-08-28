reportextension 52102 "NTS Posted Assembly Order" extends "Posted Assembly Order"
{
    RDLCLayout = './src/reportextension/Layouts/PostedAssemblyOrder.rdl';
    dataset
    {
        add("Posted Assembly Header")
        {
            column(NTSTracking_PostedAssemblyHeader; GetAssmHeaderSerial("Posted Assembly Header"."No.", "Posted Assembly Header"."Item No."))
            { }
            column(NTSWorkDescription; WorkDescription)
            { }
            column(NTSIsDisAssembly; "Posted Assembly Header"."NBT_DIS Disassembly")
            { }
        }
        add("Posted Assembly Line")
        {
            column(NTSLine_No_; "Line No.")
            { }
            column(NTSHideLotSerialInfo; HideLotSerialInfo)
            { }
        }
        modify("Posted Assembly Header")
        {
            trigger OnAfterAfterGetRecord()
            begin
                Clear(WorkDescription);
                WorkDescription := "Posted Assembly Header".GetWorkDescription();
                HideLotSerialInfo := false;
            end;
        }
        modify("Posted Assembly Line")
        {
            trigger OnAfterAfterGetRecord()
            var
                Item: Record Item;
            begin
                if Item.Get("Posted Assembly Line"."No.") and (Item."Item Tracking Code" = '') then
                    HideLotSerialInfo := true
                else
                    HideLotSerialInfo := false;
            end;
        }
        addlast("Posted Assembly Line")
        {
            dataitem("Item Ledger Entry"; "Item Ledger Entry")
            {
                DataItemLinkReference = "Posted Assembly Line";
                DataItemLink = "Document No." = FIELD("Document No."), "Document Line No." = FIELD("Line No."), "Item No." = FIELD("No.");
                DataItemTableView = where("Document Type" = const("Posted Assembly"), "Entry Type" = const("Assembly Consumption"));

                column(NTSLotNo; "Lot No.")
                { }
                column(NTSSerialNo; "Serial No.")
                { }
                column(NTSExpirationDate2; "Expiration Date")
                { }
                column(NTSEntry_No_; "Entry No.")
                { }
                column(NTSQuantity; Quantity)
                { }
            }
        }
    }
    labels
    {
        BOMCaption = 'BOM';
        LotOrSerialCaption = 'LOT/SERIAL#';
        SerialCaption = 'SERIAL#';
        WorkDescriptionCaption = 'Work Description';
        PostedDisAssemblyReportCaption = 'Posted Disassembly Order';
        ExpirationDateCapiton = 'Expiration Date';
    }

    local procedure GetAssmHeaderSerial(DocumentNo: Code[20]; ItemNo: Code[20]): Text
    var
        ItemLedgerEntry: Record "Item Ledger Entry";
        LotNo: Text;
        SerialNo: Text;
    begin
        Clear(SerialNo);
        Clear(LotNo);

        if "Posted Assembly Header"."NBT_DIS Disassembly" then begin
            if "Posted Assembly Header"."NTS Serial No." <> '' then
                if SerialNo = '' then
                    SerialNo := "Posted Assembly Header"."NTS Serial No.";
        end else if "Posted Assembly Header"."NTS Disassembly Component Only" then begin
            if "Posted Assembly Header"."NTS Serial No." <> '' then
                if SerialNo = '' then
                    SerialNo := "Posted Assembly Header"."NTS Serial No.";
        end else begin
            ItemLedgerEntry.Reset();
            ItemLedgerEntry.SetRange("Document No.", DocumentNo);
            ItemLedgerEntry.SetRange("Document Type", ItemLedgerEntry."Document Type"::"Posted Assembly");
            ItemLedgerEntry.SetRange("Entry Type", ItemLedgerEntry."Entry Type"::"Assembly Output");
            ItemLedgerEntry.SetRange("Item No.", ItemNo);

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
        end;
        if SerialNo <> '' then
            exit(SerialNo)
        else
            exit(LotNo);
    end;

    var
        WorkDescription: Text;
        HideLotSerialInfo: Boolean;
}