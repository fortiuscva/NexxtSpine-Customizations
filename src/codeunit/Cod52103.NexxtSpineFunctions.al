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
        NextLineNo: Integer;


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
        CustNoBlankError: Label 'Customer No. is blank on this %1';
    begin
        DoRHeader.TestField(Customer);
        CreateSalesOrder(DoRHeader);
        DoRHeader.Posted := true;
        DoRHeader.Modify();
    end;

    procedure CreateSalesOrder(DoRHeader: Record "NTS DoR Header")
    var
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        DoRLine: Record "NTS DoR Line";
        CreateReservEntry: Codeunit "Create Reserv. Entry";
        ForReservEntry: Record "Reservation Entry";
        TrackingSpec: Record "Tracking Specification";
        ItemTrackingVal: integer;
    begin
        SalesHeader.Init();
        SalesHeader."Document Type" := SalesHeader."Document Type"::Order;
        SalesHeader."No." := '';
        SalesHeader.Insert(true);
        SalesHeader.Validate("Sell-to Customer No.", DoRHeader."Customer");
        SalesHeader.validate("NTS DoR Number", DoRHeader."No.");
        SalesHeader.Validate(Status, SalesHeader.Status::Open);
        SalesHeader.Validate("NTS Surgeon", DoRHeader.Surgeon);
        SalesHeader.Validate("NTS Distributor", DoRHeader.Distributor);
        SalesHeader.Validate("NTS Reps", DoRHeader.Reps);
        SalesHeader.Validate("NTS Set Name", DoRHeader."Set Name");
        SalesHeader.Modify(true);

        NextLineNo := 10000;
        DoRLine.Reset();
        DoRLine.SetRange("Document No.", DoRHeader."No.");
        if DoRLine.FindSet() then
            repeat
                SalesLine.Init();
                SalesLine."Document Type" := SalesLine."Document Type"::Order;
                SalesLine."Document No." := SalesHeader."No.";
                SalesLine."Line No." := NextLineNo;
                SalesLine.Insert(True);
                SalesLine."Type" := SalesLine."Type"::Item;
                SalesLine.Validate("No.", DoRLine."Item No.");
                SalesLine.Validate(Quantity, DoRLine.Quantity);
                SalesLine.Validate("NTS Lot Number", DoRLine."Lot No.");
                SalesLine.Validate("NTS DOR No.", DoRLine."Document No.");
                SalesLine.Validate("NTS DOR Line No.", DoRLine."Line No.");
                SalesLine.Validate("Posting Date", DoRHeader."Posting Date");
                SalesLine.Modify(True);
                NextLineNo += 10000;

                ItemTrackingVal := FindItemTrackingCode(SalesLine."No.");
                if (ItemTrackingVal <> 0) then begin

                    ForReservEntry."Lot No." := DoRLine."Lot No.";
                    //ForReservEntry."Serial No." := DoRLine."Serial No.";
                    TrackingSpec."New Lot No." := DoRLine."Lot No.";
                    //TrackingSpec."New Serial No." := InspHeadRecPar."Serial No.";

                    CreateReservEntry.CreateReservEntryFor(
                    Database::"Sales Line", 1,
                    SalesLine."Document No.", '',
                    0, SalesLine."Line No.",
                    SalesLine."Qty. per Unit of Measure", SalesLine.Quantity, SalesLine."Quantity (Base)",
                    ForReservEntry);
                    //CreateReservEntry."Warranty Date" := OldReservEntry."Warranty Date";
                    //CreateReservEntry.SetDates(0D, ILERecLcl."Expiration Date");
                    //CreateReservEntry.SetNewExpirationDate(ILERecLcl."Expiration Date");
                    CreateReservEntry.SetNewTrackingFromNewTrackingSpecification(TrackingSpec);
                    //CreateReservEntry.SetApplyToEntryNo(InspHeadRecPar."Item Ledger Entry No.");
                    CreateReservEntry.CreateEntry(
                    SalesLine."No.", SalesLine."Variant Code",
                    SalesLine."Location Code", SalesLine.Description,
                    0D, SalesLine."Shipment Date",
                    0, ForReservEntry."Reservation Status"::Surplus);
                end;
            until DoRLine.Next() = 0;
        DisassembleSet(DoRHeader);
        Message('Sales Order created, Sales Order No.:%1', SalesHeader."No.");
    end;

    procedure DisassembleSet(DoRHeader: Record "NTS DoR Header")
    var
        DoRLine: Record "NTS DoR Line";
        ItemJournalLine: Record "Item Journal Line";
        BOMComponent: Record "BOM Component";
        Customer: Record Customer;
        LocationCode: Code[10];
        SetLotNo: Code[50];
        ItemJnlPostLine: Codeunit "Item Jnl.-Post Line";
        CreateReservEntry: Codeunit "Create Reserv. Entry";
        ForReservEntry: Record "Reservation Entry";
        TrackingSpec: Record "Tracking Specification";
        ItemTrackingVal: integer;
    begin
        if Customer.Get(DoRHeader."Distributor") then
            LocationCode := Customer."Location Code";

        SalesReceivablesSetup.Get();

        // Negative adjustment for the Set
        ItemJournalLine.Reset();
        ItemJournalLine.SetRange("Journal Template Name", SalesReceivablesSetup."NTS DOR Journal Template Name");
        ItemJournalLine.SetRange("Journal Batch Name", SalesReceivablesSetup."NTS DOR Journal Batch Name");
        if ItemJournalLine.FindLast() then
            NextLineNo := ItemJournalLine."Line No." + 10000;
        ItemJournalLine.Init();
        ItemJournalLine."Journal Template Name" := SalesReceivablesSetup."NTS DOR Journal Template Name";
        ItemJournalLine."Journal Batch Name" := SalesReceivablesSetup."NTS DOR Journal Batch Name";
        ItemJournalLine."Line No." := NextLineNo;
        // ItemJournalLine.Insert(true);
        ItemJournalLine.Validate("Entry Type", ItemJournalLine."Entry Type"::"Negative Adjmt.");
        ItemJournalLine.Validate("Item No.", DoRHeader."Set Name");
        ItemJournalLine.Validate("Document No.", DoRHeader."No.");
        ItemJournalLine.Validate(Quantity, DoRHeader.Quantity);
        ItemJournalLine.Validate("Posting Date", DoRHeader."Posting Date");
        ItemJournalLine.Validate("Location Code", LocationCode);
        // ItemJournalLine.Validate("Serial No.", DoRHeader."Serial No.");
        // ItemJournalLine.Validate("Lot No.", DoRHeader."Lot No.");
        // ItemJournalLine.Modify(true);
        NextLineNo += 10000;

        ItemTrackingVal := FindItemTrackingCode(ItemJournalLine."Item No.");
        if (ItemTrackingVal <> 0) then begin
            if ItemTrackingVal = 2 then begin
                ForReservEntry."Serial No." := DoRHeader."Serial No.";
                TrackingSpec."New Serial No." := DoRHeader."Serial No.";
            end else begin
                ForReservEntry."Lot No." := DoRHeader."Lot No.";
                ForReservEntry."Serial No." := DoRHeader."Serial No.";
                TrackingSpec."New Lot No." := DoRHeader."Lot No.";
                TrackingSpec."New Serial No." := DoRHeader."Serial No.";
            end;
            CreateReservEntry.CreateReservEntryFor(
            Database::"Item Journal Line", 3,
            'ITEM', ItemJournalLine."Journal Batch Name",
            0, ItemJournalLine."Line No.",
            ItemJournalLine."Qty. per Unit of Measure", ItemJournalLine.Quantity, ItemJournalLine."Quantity (Base)",
            ForReservEntry);
            CreateReservEntry.SetNewTrackingFromNewTrackingSpecification(TrackingSpec);
            CreateReservEntry.CreateEntry(
            ItemJournalLine."Item No.", ItemJournalLine."Variant Code",
            ItemJournalLine."Location Code", ItemJournalLine.Description,
            0D, ItemJournalLine."Posting Date",
            0, ForReservEntry."Reservation Status"::Prospect);
            ItemJnlPostLine.RunWithCheck(ItemJournalLine);
        end;
        DoRLine.Reset();
        DoRLine.SetRange("Document No.", DoRHeader."No.");
        if DoRLine.FindSet() then
            repeat
                // Explode BOM and create positive entries for components
                Clear(ItemJnlPostLine);
                ItemJournalLine.Init();
                ItemJournalLine."Journal Template Name" := SalesReceivablesSetup."NTS DOR Journal Template Name";
                ItemJournalLine."Journal Batch Name" := SalesReceivablesSetup."NTS DOR Journal Batch Name";
                ItemJournalLine."Line No." := NextLineNo;
                // ItemJournalLine.Insert(true);
                ItemJournalLine.Validate("Entry Type", ItemJournalLine."Entry Type"::"Positive Adjmt.");
                ItemJournalLine.Validate("Item No.", DoRLine."Item No.");
                ItemJournalLine.Validate("Document No.", DoRLine."Document No.");
                ItemJournalLine.Validate(Quantity, DoRLine.Quantity);
                ItemJournalLine.Validate("Posting Date", DoRHeader."Posting Date");
                ItemJournalLine.Validate("Location Code", LocationCode);
                // ItemJournalLine.Validate("Serial No.", DoRHeader."Serial No.");
                // ItemJournalLine.Validate("Lot No.", DoRLine."Lot No.");
                // ItemJournalLine.Modify(true);
                NextLineNo += 10000;

                ItemTrackingVal := FindItemTrackingCode(ItemJournalLine."Item No.");
                if (ItemTrackingVal <> 0) then begin
                    if ItemTrackingVal = 1 then begin
                        ForReservEntry."Lot No." := DoRLine."Lot No.";
                        TrackingSpec."New Lot No." := DoRLine."Lot No.";
                    end else begin
                        ForReservEntry."Lot No." := DoRLine."Lot No.";
                        TrackingSpec."New Lot No." := DoRLine."Lot No.";
                    end;


                    CreateReservEntry.CreateReservEntryFor(
                    Database::"Item Journal Line", 2,
                    'ITEM', ItemJournalLine."Journal Batch Name",
                    0, ItemJournalLine."Line No.",
                    ItemJournalLine."Qty. per Unit of Measure", ItemJournalLine.Quantity, ItemJournalLine."Quantity (Base)",
                    ForReservEntry);
                    CreateReservEntry.SetNewTrackingFromNewTrackingSpecification(TrackingSpec);
                    CreateReservEntry.CreateEntry(
                    ItemJournalLine."Item No.", ItemJournalLine."Variant Code",
                    ItemJournalLine."Location Code", ItemJournalLine.Description,
                    0D, ItemJournalLine."Posting Date",
                    0, ForReservEntry."Reservation Status"::Prospect);
                    ItemJnlPostLine.RunWithCheck(ItemJournalLine);
                end;
            until DoRLine.Next() = 0;
    end;

    procedure CreatePositiveAdjustment(SalesHeader: Record "Sales Header")
    var
        SalesLine: Record "Sales Line";
        ItemJournalLine: Record "Item Journal Line";
        LocationRec: Record Location;
        FinishedGoodsLocation: Code[10];
        ItemJournalTemplate: Record "Item Journal Template";
        ItemJournalBatch: Record "Item Journal Batch";
        ItemJournalPost: Codeunit "Item Jnl.-Post";
        ItemJnlPostLine: Codeunit "Item Jnl.-Post Line";
        CreateReservEntry: Codeunit "Create Reserv. Entry";
        ForReservEntry: Record "Reservation Entry";
        TrackingSpec: Record "Tracking Specification";
        DORLine: Record "NTS DOR Line";
        ItemTrackingVal: integer;
    begin
        // Get Finished Goods Location
        LocationRec.Reset;
        LocationRec.SetRange("NTS Finished Goods Location", true);
        LocationRec.FindFirst();
        SalesReceivablesSetup.Get();
        // Create journal lines
        NextLineNo := 10000;
        SalesLine.Reset();
        SalesLine.SetRange("Document Type", SalesLine."Document Type"::Order);
        SalesLine.SetRange("Document No.", SalesHeader."No.");
        if SalesLine.FindSet() then
            repeat
                ItemJournalLine.Init();
                ItemJournalLine."Journal Template Name" := SalesReceivablesSetup."NTS DOR Journal Template Name";
                ItemJournalLine."Journal Batch Name" := SalesReceivablesSetup."NTS DOR Journal Batch Name";
                ItemJournalLine."Line No." := NextLineNo;
                // ItemJournalLine.INSERT(TRUE);
                ItemJournalLine.VALIDATE("Entry Type", ItemJournalLine."Entry Type"::"Positive Adjmt.");
                ItemJournalLine.VALIDATE("Item No.", SalesLine."No.");
                ItemJournalLine.VALIDATE("Document No.", SalesLine."Document No.");
                ItemJournalLine.VALIDATE(Quantity, SalesLine.Quantity);
                ItemJournalLine.VALIDATE("Location Code", LocationRec.Code);
                ItemJournalLine.VALIDATE("Unit of Measure Code", SalesLine."Unit of Measure Code");
                ItemJournalLine.VALIDATE("Posting Date", SalesHeader."Posting Date");
                // ItemJournalLine.Modify(TRUE);

                DORLine.get(SalesLine."NTS DOR No.", SalesLine."NTS DOR Line No.");
                ItemTrackingVal := FindItemTrackingCode(ItemJournalLine."Item No.");
                if (ItemTrackingVal <> 0) then begin
                    ForReservEntry."Lot No." := DoRLine."Lot No.";
                    TrackingSpec."New Lot No." := DoRLine."Lot No.";

                    CreateReservEntry.CreateReservEntryFor(
                    Database::"Item Journal Line", 2,
                    'ITEM', ItemJournalLine."Journal Batch Name",
                    0, ItemJournalLine."Line No.",
                    ItemJournalLine."Qty. per Unit of Measure", ItemJournalLine.Quantity, ItemJournalLine."Quantity (Base)",
                    ForReservEntry);
                    CreateReservEntry.SetNewTrackingFromNewTrackingSpecification(TrackingSpec);
                    CreateReservEntry.CreateEntry(
                    ItemJournalLine."Item No.", ItemJournalLine."Variant Code",
                    ItemJournalLine."Location Code", ItemJournalLine.Description,
                    0D, ItemJournalLine."Posting Date",
                    0, ForReservEntry."Reservation Status"::Prospect);
                    ItemJnlPostLine.RunWithCheck(ItemJournalLine);
                end;
            until SalesLine.Next() = 0;
    end;

    procedure CreateAssemblyOrder(TransferHeader: Record "Transfer Header")
    var
        AssemblyHeader: Record "Assembly Header";
        AssemblyLine: Record "Assembly Line";
        TransLine: Record "Transfer Line";
        NextLineNo: Integer;
        ItemTrackingVal: Integer;
        NTSDORLine: Record "NTS DOR Line";
        CreateReservEntry: Codeunit "Create Reserv. Entry";
        ForReservEntry: Record "Reservation Entry";
        TrackingSpec: Record "Tracking Specification";
    begin
        AssemblyHeader.Init();
        AssemblyHeader."Document Type" := AssemblyHeader."Document Type"::Order;
        AssemblyHeader."No." := '';
        AssemblyHeader.Insert(true);
        AssemblyHeader.Validate("Item No.", TransferHeader."NTS Set Name");
        AssemblyHeader.Validate("Posting Date", TransferHeader."Posting Date");
        AssemblyHeader.Validate("Due Date", TransferHeader."Posting Date");
        AssemblyHeader.Validate("Starting Date", TransferHeader."Posting Date");
        AssemblyHeader.Validate("Ending Date", TransferHeader."Posting Date");
        AssemblyHeader.Validate("Location Code", TransferHeader."Transfer-to Code");
        AssemblyHeader.Validate("Shortcut Dimension 1 Code", TransferHeader."Shortcut Dimension 1 Code");
        AssemblyHeader.Validate("Shortcut Dimension 2 Code", TransferHeader."Shortcut Dimension 2 Code");
        AssemblyHeader.Validate("NTS DOR No.", TransferHeader."NTS DOR No.");
        AssemblyHeader.Modify(true);

        NextLineNo := 10000;
        TransLine.Reset();
        TransLine.SetRange("Document No.", TransferHeader."No.");
        TransLine.Setrange("Derived From Line No.", 0);

        if TransLine.FindSet() then
            repeat
                AssemblyLine.Init();
                AssemblyLine."Document Type" := AssemblyLine."Document Type"::Order;
                AssemblyLine."Document No." := AssemblyHeader."No.";
                AssemblyLine."Line No." := NextLineNo;
                AssemblyLine.Insert(True);
                AssemblyLine.Validate(Type, AssemblyLine.Type::Item);
                AssemblyLine.Validate("No.", TransLine."Item No.");
                AssemblyLine.Validate(Quantity, TransLine.Quantity);
                AssemblyLine.Validate("Unit of Measure Code", TransLine."Unit of Measure Code");
                AssemblyLine.Validate("NTS DOR No.", TransLine."NTS DOR No.");
                AssemblyLine.Validate("NTS DOR Line No.", TransLine."NTS DOR Line No.");
                AssemblyLine.Modify(true);
                NextLineNo += 10000;

                ItemTrackingVal := FindItemTrackingCode(AssemblyLine."No.");
                if (ItemTrackingVal <> 0) then begin
                    NTSDORLine.Get(AssemblyLine."NTS DOR No.", AssemblyLine."NTS DOR Line No.");
                    ForReservEntry."Lot No." := NTSDORLine."Lot No.";
                    TrackingSpec."New Lot No." := NTSDORLine."Lot No.";

                    CreateReservEntry.CreateReservEntryFor(
                    Database::"Assembly Line", 1,
                    AssemblyLine."Document No.", '',
                    0, AssemblyLine."Line No.",
                    AssemblyLine."Qty. per Unit of Measure", AssemblyLine.Quantity, AssemblyLine."Quantity (Base)",
                    ForReservEntry);
                    CreateReservEntry.SetNewTrackingFromNewTrackingSpecification(TrackingSpec);
                    CreateReservEntry.CreateEntry(
                    AssemblyLine."No.", AssemblyLine."Variant Code",
                    AssemblyLine."Location Code", AssemblyLine.Description,
                    0D, AssemblyLine."Due Date",
                    0, ForReservEntry."Reservation Status"::Surplus);
                end;
            //ItemJnlPostLine.RunWithCheck(ItemJournalLine);
            until TransLine.Next() = 0;
        Message('Assembly Order created, Assembly Order No.:%1', AssemblyHeader."No.");
    end;

    procedure CreateTransferOrder(var SalesHeader: Record "Sales Header")
    var
        TransferHeader: Record "Transfer Header";
        TransferLine: Record "Transfer Line";
        SalesLine: Record "Sales Line";
        Location: Record Location;
        NextLineNo: Integer;
        NTSDORLine: Record "NTS DOR Line";
        CreateReservEntry: Codeunit "Create Reserv. Entry";
        ForReservEntry: Record "Reservation Entry";
        TrackingSpec: Record "Tracking Specification";
        ItemTrackingMgt: Codeunit "Item Tracking Management";
        ReservStatus: Enum "Reservation Status";
        CurrentSourceRowID: Text[250];
        SecondSourceRowID: Text[250];
        ItemTrackingVal: integer;
    begin
        Location.Reset;
        Location.SetRange("NTS Finished Goods Location", true);
        Location.FindFirst();

        TransferHeader.Init();
        TransferHeader."No." := '';
        TransferHeader.Insert(True);

        TransferHeader.Validate("Transfer-from Code", Location.Code);
        TransferHeader.Validate("Transfer-to Code", SalesHeader."Location Code");
        TransferHeader.Validate("Direct Transfer", true);
        TransferHeader.Validate("Posting Date", WorkDate());
        TransferHeader.Validate("Shortcut Dimension 1 Code", SalesHeader."Shortcut Dimension 1 Code");
        TransferHeader.Validate("Shortcut Dimension 2 Code", SalesHeader."Shortcut Dimension 2 Code");
        TransferHeader.Validate("Assigned User ID", SalesHeader."Salesperson Code");
        TransferHeader.Validate("Shipment Date", SalesHeader."Shipment Date");
        TransferHeader.Validate("Shipping Agent Code", SalesHeader."Shipping Agent Code");
        TransferHeader.Validate("Shipping Time", SalesHeader."Shipping Time");
        TransferHeader.Validate("NTS Set Name", SalesHeader."NTS Set Name");
        TransferHeader.Validate("NTS DOR No.", SalesHeader."NTS DoR Number");
        TransferHeader.Modify(true);

        NextLineNo := 10000;
        SalesLine.Reset();
        SalesLine.SetRange("Document Type", SalesHeader."Document Type");
        SalesLine.SetRange("Document No.", SalesHeader."No.");
        SalesLine.SetRange(Type, SalesLine.Type::Item);
        SalesLine.SetFilter("No.", '<>%1', '');
        if SalesLine.FindSet() then
            repeat
                TransferLine.Init();
                TransferLine."Document No." := TransferHeader."No.";
                TransferLine."Line No." := NextLineNo;
                TransferLine.Insert(true);

                TransferLine.Validate("Item No.", SalesLine."No.");
                TransferLine.Validate(Quantity, SalesLine.Quantity);
                TransferLine.Validate("Unit of Measure Code", SalesLine."Unit of Measure Code");
                TransferLine.Validate("NTS Sales Order No.", SalesLine."Document No.");
                TransferLine.Validate("NTS Sales Order Line No.", SalesLine."Line No.");
                TransferLine.Validate("NTS DOR No.", SalesLine."NTS DOR No.");
                TransferLine.Validate("NTS DOR Line No.", SalesLine."NTS DOR Line No.");
                TransferLine.Modify(true);
                if NTSDORLine.Get(TransferLine."NTS DOR No.", TransferLine."NTS DOR Line No.") then begin
                    if not NTSDORLine.Consumed then begin
                        ItemTrackingVal := FindItemTrackingCode(TransferLine."Item No.");
                        if (ItemTrackingVal <> 0) then begin
                            ForReservEntry.Init();
                            ForReservEntry."Lot No." := NTSDORLine."Lot No.";
                            TrackingSpec."New Lot No." := NTSDORLine."Lot No.";


                            CreateReservEntry.SetDates(0D, ForReservEntry."Expiration Date");
                            CreateReservEntry.CreateReservEntryFor(
                              Database::"Transfer Line", 0,
                              TransferLine."Document No.", '', TransferLine."Derived From Line No.", TransferLine."Line No.", TransferLine."Qty. per Unit of Measure",
                              TransferLine.Quantity, TransferLine."Quantity (Base)" * TransferLine."Qty. per Unit of Measure", ForReservEntry);
                            CreateReservEntry.CreateEntry(
                              TransferLine."Item No.", TransferLine."Variant Code", TransferLine."Transfer-from Code", '', TransferLine."Receipt Date", TransferLine."Shipment Date", 0, ReservStatus::Surplus);

                            CurrentSourceRowID := ItemTrackingMgt.ComposeRowID(Database::"Transfer Line", 0, TransferLine."Document No.", '', 0, TransferLine."Line No.");

                            SecondSourceRowID := ItemTrackingMgt.ComposeRowID(Database::"Transfer Line", 1, TransferLine."Document No.", '', 0, TransferLine."Line No.");

                            ItemTrackingMgt.SynchronizeItemTracking(CurrentSourceRowID, SecondSourceRowID, '');
                        end;
                        NextLineNo += 10000;
                    end;
                end;
            until SalesLine.Next() = 0;
        Message('Transfer Order created, Transfer Order No.:%1', TransferHeader."No.");
        SalesHeader.Validate("NTS Is TO Created", true);
        SalesHeader.Modify();
    end;

    procedure FindItemTrackingCode(ItemNoPar: Code[20]) TrackingType: Integer
    var
        ItemTrackingCodeRecLcl: Record "Item Tracking Code";
        ItemRecLcl: Record Item;
    begin
        ItemRecLcl.GET(ItemNoPar);
        IF ItemRecLcl."Item Tracking Code" = '' THEN
            EXIT(0); //No Tracking

        ItemTrackingCodeRecLcl.GET(ItemRecLcl."Item Tracking Code");
        IF ItemTrackingCodeRecLcl."SN Specific Tracking" THEN
            IF ItemTrackingCodeRecLcl."Lot Specific Tracking" THEN
                EXIT(3) //Lot Serial Combo
            ELSE
                EXIT(2) //Serial Specific
        ELSE
            IF ItemTrackingCodeRecLcl."Lot Specific Tracking" THEN
                EXIT(1); //Lot Specific
        EXIT(0);
    end;


    var
        SalesReceivablesSetup: Record "Sales & Receivables Setup";
}
