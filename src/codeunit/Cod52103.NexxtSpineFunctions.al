codeunit 52103 "NTS NexxtSpine Functions"
{
    var
        Customer: Record Customer;
        Item: Record Item;
        TempSalesHeader: Record "Sales Header" temporary;
        TempSalesLine: Record "Sales Line" temporary;
        PriceCalculationMgt: Codeunit "Price Calculation Mgt.";
        PriceType: Enum "Price Type";
        LineWithPrice: Interface "Line With Price";
        PriceCalculation: interface "Price Calculation";
        SVariant: Variant;

    procedure GetUnitPriceAndDiscount(distributorNo: Code[20]; itemNo: Code[20]; var unitPrice: Decimal; var discountPct: Decimal)
    begin
        unitPrice := 0;
        discountPct := 0;
        if Item.Get(itemNo) then begin
            TempSalesHeader."No." := 'PRICETST';
            TempSalesHeader.Validate("Sell-to Customer No.", distributorNo);
            TempSalesLine.Type := TempSalesLine.Type::Item;
            TempSalesLine."No." := Item."No.";
            TempSalesLine."Unit of Measure Code" := Item."Base Unit of Measure";
            TempSalesLine."Posting Date" := Today;
            if Customer.get(distributorNo) then begin
                TempSalesLine."Customer Price Group" := Customer."Customer Price Group";
                TempSalesLine."Customer Disc. Group" := Customer."Customer Disc. Group";
            end;
            Commit();
            TempSalesLine.GetLineWithPrice(LineWithPrice);
            LineWithPrice.SetLine(PriceType::Sale, TempSalesHeader, TempSalesLine);
            PriceCalculationMgt.GetHandler(LineWithPrice, PriceCalculation);
            PriceCalculation.PickPrice();
            PriceCalculation.GetLine(SVariant);
            TempSalesLine := SVariant;
            unitPrice := TempSalesLine."Unit Price";
            discountPct := TempSalesLine."Line Discount %";
        end;
    end;

    procedure PostDoR(var DoRHeader: Record "NTS DoR Header")
    var
        DoRLine: Record "NTS DoR Line";
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        TransferHeader: Record "Transfer Header";
        TransferLine: Record "Transfer Line";
    begin
        CreateSalesOrder(DoRHeader);
        DisassembleSet(DoRHeader);
        DoRHeader.Status := DoRHeader.Status::Posted;
        DoRHeader.Modify();
    end;

    procedure CreateSalesOrder(DoRHeader: Record "NTS DoR Header")
    var
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        DoRLine: Record "NTS DoR Line";
    begin
        SalesHeader.Init();
        SalesHeader."Document Type" := SalesHeader."Document Type"::Order;
        SalesHeader."No." := '';
        SalesHeader.Insert(true);
        SalesHeader.Validate("Sell-to Customer No.", DoRHeader."Customer");
        SalesHeader.validate("NTS DoR Number", DoRHeader."DoR Number");
        SalesHeader.Validate(Status, SalesHeader.Status::Open);
        SalesHeader.Validate("NTS Surgeon", DoRHeader.Surgeon);
        SalesHeader.Validate("NTS Distributor", DoRHeader.Distributor);
        SalesHeader.Validate("NTS Reps", DoRHeader.Reps);
        SalesHeader.Modify(true);

        DoRLine.SetRange("DoR Number", DoRHeader."DoR Number");
        if DoRLine.FindSet() then
            repeat
                SalesLine.Init();
                SalesLine."Document Type" := SalesLine."Document Type"::Order;
                SalesLine."Document No." := SalesHeader."No.";
                SalesLine."Line No." := DoRLine."Line No.";
                SalesLine.Insert(True);
                SalesLine."Type" := SalesLine."Type"::Item;
                SalesLine.Validate("No.", DoRLine."Item No.");
                SalesLine.Validate(Quantity, DoRLine.Quantity);
                SalesLine.Validate("NTS Lot Number", DoRLine."Lot Number");
                SalesLine.Modify(True);
            until DoRLine.Next() = 0;

    end;

    procedure DisassembleSet(DoRHeader: Record "NTS DoR Header")
    var
        DoRLine: Record "NTS DoR Line";
        ItemJournalLine: Record "Item Journal Line";
        BOMComponent: Record "BOM Component";
        Customer: Record Customer;
        LocationCode: Code[10];
    begin
        Customer.Get(DoRHeader."Distributor");
        LocationCode := Customer."Location Code";

        DoRLine.SetRange("DoR Number", DoRHeader."DoR Number");
        if DoRLine.FindSet() then
            repeat
                // Negative adjustment for the Set
                ItemJournalLine.Init();
                ItemJournalLine."Journal Template Name" := 'ITEM';
                ItemJournalLine."Journal Batch Name" := 'DEFAULT';
                ItemJournalLine."Line No." := DoRLine."Line No.";
                ItemJournalLine.Insert(true);
                ItemJournalLine."Entry Type" := ItemJournalLine."Entry Type"::"Negative Adjmt.";
                ItemJournalLine."Item No." := DoRHeader."Set Name";
                ItemJournalLine.Quantity := DoRLine.Quantity;
                ItemJournalLine."Location Code" := LocationCode;
                ItemJournalLine."Serial No." := DoRHeader."Serial Number";
                ItemJournalLine."Lot No." := DoRLine."Lot Number";
                ItemJournalLine.Modify(true);

                // Explode BOM and create positive entries for components
                BOMComponent.SetRange("Parent Item No.", DoRHeader."Set Name");
                if BOMComponent.FindSet() then
                    repeat
                        ItemJournalLine.Init();
                        ItemJournalLine."Journal Template Name" := 'ITEM';
                        ItemJournalLine."Journal Batch Name" := 'DEFAULT';
                        ItemJournalLine."Line No." := DoRLine."Line No.";
                        ItemJournalLine.Insert(true);
                        ItemJournalLine."Entry Type" := ItemJournalLine."Entry Type"::"Positive Adjmt.";
                        ItemJournalLine."Item No." := BOMComponent."No.";
                        ItemJournalLine.Quantity := BOMComponent."Quantity per";
                        ItemJournalLine."Location Code" := LocationCode;
                        ItemJournalLine."Serial No." := DoRHeader."Serial Number";
                        ItemJournalLine."Lot No." := DoRLine."Lot Number";
                        ItemJournalLine.Modify(true);
                    until BOMComponent.Next() = 0;
            until DoRLine.Next() = 0;
    end;

    var
        NewLineNo: Integer;

}
