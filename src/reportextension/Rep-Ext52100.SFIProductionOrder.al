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
            column(NTSQRCodeText; GenerateQRCode(GetGTIN("Item No.") + '|' + GetLotNo("Prod. Order No.", "Line No.")))
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
        TrackingSpec: Record "Tracking Specification";
    begin
        TrackingSpec.SetRange("Source Type", DATABASE::"Prod. Order Line");
        TrackingSpec.SetRange("Source ID", ProdOrderNo);
        if TrackingSpec.FindFirst() then
            exit(TrackingSpec."Lot No.");
        exit('');
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

}
