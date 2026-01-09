tableextension 52134 "NTS Purchase line" extends "Purchase line"
{
    fields
    {
        field(52100; "NTS RPO Lot No."; Text[2048])
        {
            Caption = 'RPO Lot No.';
            DataClassification = CustomerContent;
            Editable = false;
        }
    }
    local procedure AssignRpoLotCsv()
    var
        Lottext: Text;
    begin
        if ("Prod. Order No." = '') then
            exit;

        Lottext := BuildRpoLotCsv("Prod. Order No.", "Prod. Order Line No.");


        if "NTS RPO Lot No." <> Lottext then
            "NTS RPO Lot No." := Lottext;
    end;

    local procedure BuildRpoLotCsv(ProdOrderNo: Code[20]; ProdOrderLineNo: Integer): Text
    var
        TrackSpec: Record "Tracking Specification";
        Csv: Text;
        LotTxt: Text;
    begin
        if ProdOrderNo = '' then
            exit('');

        TrackSpec.Reset();
        TrackSpec.SetRange("Source Type", Database::"Prod. Order Line");
        TrackSpec.SetRange("Source ID", ProdOrderNo);
        if ProdOrderLineNo <> 0 then
            TrackSpec.SetRange("Source Ref. No.", ProdOrderLineNo);
        TrackSpec.SetFilter("Lot No.", '<>%1', '');

        if TrackSpec.FindSet() then
            repeat
                LotTxt := TrackSpec."Lot No.";
                AppendCsvDistinct(Csv, LotTxt);
                if StrLen(Csv) >= 2048 then begin
                    Csv := CopyStr(Csv, 1, 2048);
                    exit(Csv);
                end;
            until TrackSpec.Next() = 0;

        exit(Csv);
    end;


    local procedure AppendCsvDistinct(var Csv: Text; Token: Text)
    var
        PaddedCsv: Text;
        Probe: Text;
    begin
        if Token = '' then
            exit;

        Probe := ',' + Token + ',';
        PaddedCsv := ',' + Csv + ',';
        if StrPos(PaddedCsv, Probe) = 0 then begin
            if Csv = '' then
                Csv := Token
            else
                Csv := Csv + ',' + Token;
        end;
    end;

}
