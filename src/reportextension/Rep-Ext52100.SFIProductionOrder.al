reportextension 52100 "NTS SFI Production Order" extends "SFI Production Order"
{
    dataset
    {
        add("Prod. Order Line")
        {
            column(NTSGTIN; GetGTIN("Prod. Order Line"."Item No."))
            {
            }
            column(LotNumber; GetLotNo("Prod. Order No.", "Line No."))
            {
            }
            //column(NTSQRCodeImageBlob; QRCodeBlob) { }
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
        TrackingSpec: Record "Tracking Specification";
    begin
        TrackingSpec.SetRange("Source Type", DATABASE::"Prod. Order Line");
        TrackingSpec.SetRange("Source ID", ProdOrderNo);
        if TrackingSpec.FindFirst() then
            exit(TrackingSpec."Lot No.");
        exit('');
    end;


    local procedure GenerateQRCodeImage(GTIN: Code[20]; LotNo: Code[50])
    var
        EncodedText: Text;
    begin
        QRCodeText := 'GTIN:' + GTIN + '; Lot#:' + LotNo;

        BarcodeFontProvider2D := Enum::"Barcode Font Provider 2D"::IDAutomation2D;
        BarcodeSymbology2D := Enum::"Barcode Symbology 2D"::"QR-Code";
        EncodedText := BarcodeFontProvider2D.EncodeFont(QRCodeText, BarcodeSymbology2D);

        QRCodeBlob.CreateOutStream(OutStream);
        OutStream.WriteText(EncodedText);
    end;


    var

        QRCodeText: Text;
        QRCodeBlob: Codeunit "Temp Blob";
        OutStream: OutStream;
        BarcodeFontProvider2D: Interface "Barcode Font Provider 2D";
        BarcodeSymbology2D: Enum "Barcode Symbology 2D";

}
