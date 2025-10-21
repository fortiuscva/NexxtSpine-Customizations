reportextension 52100 "NTS SFI Production Order" extends "SFI Production Order"
{

    RDLCLayout = './src/reportextension/Layouts/SFI Production Order-azure.rdlc';

    dataset
    {
        add("Prod. Order Line")
        {
            column(NTSQRCode; GenerateQRCode(GetGTIN("Item No.") + ',' + GetLotNo("Prod. Order No.", "Line No.")))
            {
            }
            column(NTSQRCodeText; GetGTIN("Item No.") + ',' + GetLotNo("Prod. Order No.", "Line No."))
            {
            }
            column(NTSLaserEtchQRCodeLbl; LaserEtchQRCodeLbl)
            {
            }
            column(NTSDrawingNo; GetDrawingNo("Item No."))
            {
            }
            column(NTSRevisionLevel; GetRevisionLevel("Item No."))
            {
            }

            column(NTSLotOrSerial; GetLotOrSerial("Prod. Order No.", "Line No."))
            {
            }

        }
    }
    local procedure GetLotOrSerial(ProdOrderNo: Code[20]; LineNo: Integer): Code[50]
    var
        ReservationEntryRec: Record "Reservation Entry";
    begin
        ReservationEntryRec.Reset();
        ReservationEntryRec.SetRange("Source Type", DATABASE::"Prod. Order Line");
        ReservationEntryRec.SetRange("Source ID", ProdOrderNo);
        ReservationEntryRec.SetRange("Source Prod. Order Line", LineNo);
        if ReservationEntryRec.FindFirst() then begin
            if ReservationEntryRec."Lot No." <> '' then
                exit(ReservationEntryRec."Lot No.");
            if ReservationEntryRec."Serial No." <> '' then
                exit(ReservationEntryRec."Serial No.");
        end;
        exit('');
    end;

    local procedure GetDrawingNo(ItemNo: Code[20]): Code[20]
    var
        ItemRec: Record Item;
    begin
        if ItemRec.Get(ItemNo) then
            exit(ItemRec."IMP Drawing Number");
        exit('');
    end;

    local procedure GetRevisionLevel(ItemNo: Code[20]): Code[20]
    var
        ItemRec: Record Item;
    begin
        if ItemRec.Get(ItemNo) then
            exit(ItemRec."IMP Rev Level");
        exit('');
    end;

    local procedure GetGTIN(ItemNo: Code[20]): Code[20]
    var
        ItemRec: Record Item;
    begin
        if ItemRec.Get(ItemNo) then begin
            GTIN := 'GTIN(UDI): ' + ItemRec.GTIN;
            exit(GTIN);
        end;
        exit('GTIN(UDI): ');
    end;

    local procedure GetLotNo(ProdOrderNo: Code[20]; LineNo: Integer): Code[50]
    var
        ReservationEntryRec: Record "Reservation Entry";
    begin
        ReservationEntryRec.Reset();
        ReservationEntryRec.SetRange("Source Type", DATABASE::"Prod. Order Line");
        ReservationEntryRec.SetRange("Source ID", ProdOrderNo);
        ReservationEntryRec.SetRange("Source Prod. Order Line", LineNo);
        if ReservationEntryRec.FindFirst() then begin
            LotNo := 'Lot#: ' + ReservationEntryRec."Lot No.";
            exit(LotNo);
        end;
        exit('Lot#: ');
    end;

    local procedure GenerateQRCode(Value: Text): Text
    begin
        BarcodeFontProvider2D := Enum::"Barcode Font Provider 2D"::IDAutomation2D;
        BarcodeSymbology2D := Enum::"Barcode Symbology 2D"::"QR-Code";
        exit(BarcodeFontProvider2D.EncodeFont(Value, BarcodeSymbology2D));
    end;


    var
        GTIN: code[25];
        QRCodeText: Text;
        BarcodeFontProvider2D: Interface "Barcode Font Provider 2D";
        BarcodeSymbology2D: Enum "Barcode Symbology 2D";
        LaserEtchQRCodeLbl: Label 'Laser Etch QR Code.';
        LotNo: Code[50];

}