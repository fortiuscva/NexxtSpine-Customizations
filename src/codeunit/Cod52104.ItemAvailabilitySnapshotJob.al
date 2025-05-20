codeunit 52104 "Item Availability Snapshot Job"
{

    trigger OnRun()
    begin
        RebuildSnapshot();
    end;

    procedure RebuildSnapshot()
    var
        Snapshot: Record "NTS Item Availability Snapshot";
        TempCombinations: Record "NTS Item Availability Snapshot" temporary;
        ItemLedg: Record "Item Ledger Entry";
        SalesLine: Record "Sales Line";
        TotalSupply: Decimal;
        TotalDemand: Decimal;
    begin
        Snapshot.DeleteAll();

        ItemLedg.SetCurrentKey("Item No.", "Location Code");
        if ItemLedg.FindSet() then
            repeat
                if ItemLedg."Remaining Quantity" <> 0 then begin
                    TempCombinations.Reset();
                    TempCombinations."Item No." := ItemLedg."Item No.";
                    TempCombinations."Location Code" := ItemLedg."Location Code";
                    if not TempCombinations.Get(TempCombinations."Item No.", TempCombinations."Location Code") then
                        TempCombinations.Insert();
                end;
            until ItemLedg.Next() = 0;

        if TempCombinations.FindSet() then
            repeat
                TotalSupply := CalcSupply(TempCombinations."Item No.", TempCombinations."Location Code");
                TotalDemand := CalcDemand(TempCombinations."Item No.", TempCombinations."Location Code");

                Snapshot.Init();
                Snapshot."Item No." := TempCombinations."Item No.";
                Snapshot."Location Code" := TempCombinations."Location Code";
                Snapshot."Supply Qty" := TotalSupply;
                Snapshot."Demand Qty" := TotalDemand;
                Snapshot."Available Qty" := TotalSupply - TotalDemand;
                Snapshot."Last Updated" := CurrentDateTime;
                if not Snapshot.Insert() then
                    Snapshot.Modify();
            until TempCombinations.Next() = 0;
    end;

    local procedure CalcSupply(ItemNo: Code[20]; LocationCode: Code[10]): Decimal
    var
        ItemLedg: Record "Item Ledger Entry";
        Qty: Decimal;
    begin
        ItemLedg.SetRange("Item No.", ItemNo);
        ItemLedg.SetRange("Location Code", LocationCode);
        ItemLedg.CalcSums("Remaining Quantity");
        Qty := ItemLedg."Remaining Quantity";

        exit(Qty);
    end;

    local procedure CalcDemand(ItemNo: Code[20]; LocationCode: Code[10]): Decimal
    var
        SalesLine: Record "Sales Line";
        Qty: Decimal;
    begin
        SalesLine.SetRange(Type, SalesLine.Type::Item);
        SalesLine.SetRange("No.", ItemNo);
        SalesLine.SetRange("Location Code", LocationCode);
        SalesLine.SetRange("Document Type", SalesLine."Document Type"::Order);
        SalesLine.SetFilter("Outstanding Quantity", '<>0');
        SalesLine.CalcSums("Outstanding Quantity");
        Qty := SalesLine."Outstanding Quantity";

        exit(Qty);
    end;
}
