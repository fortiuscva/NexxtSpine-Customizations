reportextension 52100 "NTS SFI Production Order" extends "SFI Production Order"
{
    RDLCLayout = './src/reportextension/Layouts/SFI Production Order-azure.rdlc';

    dataset
    {
        add("Prod. Order Line")
        {
            column(NTSQRCodeText; 'GTIN(UDI): ' + GenerateQRCode(GetGTIN("Item No.") + 'Lot#: ' + GetLotNo("Prod. Order No.", "Line No.")))
            {
            }
            column(NTSLaserEtchQRCodeLbl; LaserEtchQRCodeLbl)
            {
            }
        }
    }

    local procedure GetGTIN(ItemNo: Code[20]): Code[20]
    var
        ItemRec: Record Item;
    begin
        if ItemRec.Get(ItemNo) then
            exit(ItemRec.GTIN);
        exit('');
    end;

    local procedure GetLotNo(ProdOrderNo: Code[20]; LineNo: Integer): Code[50]
    var
        ReservationEntryRec: Record "Reservation Entry";
    begin
        ReservationEntryRec.Reset();
        ReservationEntryRec.SetRange("Source Type", DATABASE::"Prod. Order Line");
        ReservationEntryRec.SetRange("Source ID", ProdOrderNo);
        ReservationEntryRec.SetRange("Source Prod. Order Line", LineNo);
        if ReservationEntryRec.FindSet() then
            repeat
                LotNo := ReservationEntryRec."Lot No.";
            until ReservationEntryRec.Next = 0;
        exit(LotNo);
    end;

    local procedure GenerateQRCode(Value: Text): Text
    begin
        BarcodeFontProvider2D := Enum::"Barcode Font Provider 2D"::IDAutomation2D;
        BarcodeSymbology2D := Enum::"Barcode Symbology 2D"::"QR-Code";
        exit(BarcodeFontProvider2D.EncodeFont(Value, BarcodeSymbology2D));
    end;


    var

        QRCodeText: Text;
        BarcodeFontProvider2D: Interface "Barcode Font Provider 2D";
        BarcodeSymbology2D: Enum "Barcode Symbology 2D";
        LaserEtchQRCodeLbl: Label 'Laser Etch QR Code.';
        LotNo: Code[50];

}