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

    procedure PostDoR(var DoRHeader: Record "NTS DoR Header"; CreateMultiple: Boolean)
    var
        DoRLine: Record "NTS DoR Line";
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        TransferHeader: Record "Transfer Header";
        TransferLine: Record "Transfer Line";
        CustNoBlankError: Label 'Customer No. is blank on this %1';
    begin
        //if CreateMultiple then begin
        CreateSalesOrdersFromMultipleDOR(DoRHeader, true)
        //end;
    end;

    procedure CreateSalesOrder(DoRHeader: Record "NTS DoR Header"; PostDisAssemblyPar: Boolean)
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
        SalesHeader.Validate("Sell-to Customer No.", DoRHeader."Customer No.");
        SalesHeader.validate("NTS DOR No.", DoRHeader."No.");
        SalesHeader.Validate(Status, SalesHeader.Status::Open);
        SalesHeader.Validate("NTS Surgeon", DoRHeader.Surgeon);
        SalesHeader.Validate("NTS Distributor", DoRHeader.Distributor);
        SalesHeader.Validate("NTS Reps.", DoRHeader."Reps.");
        SalesHeader.Validate("NTS Set Name", DoRHeader."Set Name");
        SalesHeader.Validate("Location Code", DoRHeader."Location Code");
        SalesHeader.Modify(true);

        NextLineNo := 10000;
        DoRLine.Reset();
        DoRLine.SetRange("Document No.", DoRHeader."No.");
        DoRLine.SetRange(Consumed, true);
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
                SalesLine.Validate("Location Code", DoRHeader."Location Code");
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
        if PostDisAssemblyPar then
            DisassembleSet(DoRHeader);

        Commit();
        if Confirm(StrSubstNo(SalesOrderCreatedandOpenSalesOrderMsg, SalesHeader."No.")) then
            Page.RunModal(Page::"Sales Order", SalesHeader);
    end;

    procedure CreateSalesOrdersFromMultipleDOR(var SelectedDoRHeaders: Record "NTS DoR Header"; PostDisAssemblyPar: Boolean)
    var
        DoRHeader: Record "NTS DoR Header";
        DoRLine: Record "NTS DoR Line";
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        SalesOrderDict: Dictionary of [Code[20], Code[20]];
        SalesOrderNo: Code[20];
        NextLineNo: Integer;
        CreateReservEntry: Codeunit "Create Reserv. Entry";
        ForReservEntry: Record "Reservation Entry";
        TrackingSpec: Record "Tracking Specification";
        ItemTrackingVal: integer;
        PrevCustNo: Code[20];
        PrevLocation: Code[20];
        SalesOrderCreated: Boolean;
    begin
        SalesOrderCreated := false;
        if SelectedDoRHeaders.FindSet() then
            repeat
                SelectedDoRHeaders.TestField("Customer No.");
                SelectedDoRHeaders.TestField(Status, SelectedDoRHeaders.Status::Released);
                if PostDisAssemblyPar then
                    DisassembleSet(SelectedDoRHeaders);
            until SelectedDoRHeaders.Next() = 0;

        PrevCustNo := '';
        PrevLocation := '';
        SelectedDoRHeaders.SetCurrentKey("Customer No.", "Location Code");
        if SelectedDoRHeaders.FindSet() then
            repeat
                if (PrevCustNo <> SelectedDoRHeaders."Customer No.") or (PrevLocation <> SelectedDoRHeaders."Location Code") then begin
                    SalesHeader.Init();
                    SalesHeader."Document Type" := SalesHeader."Document Type"::Order;
                    SalesHeader."No." := '';
                    SalesHeader.Insert(true);
                    SalesHeader.Validate("Sell-to Customer No.", SelectedDoRHeaders."Customer No.");
                    SalesHeader.Validate("Location Code", SelectedDoRHeaders."Location Code");
                    SalesHeader.Modify(true);

                    SalesOrderCreated := true;
                    NextLineNo := 0;
                end;

                DoRLine.Reset();
                DoRLine.SetRange("Document No.", SelectedDoRHeaders."No.");
                DoRLine.SetRange(Consumed, true);
                if DoRLine.FindSet() then
                    repeat
                        NextLineNo += 10000;
                        SalesLine.Init();
                        SalesLine."Document Type" := SalesLine."Document Type"::Order;
                        SalesLine."Document No." := SalesHeader."No.";
                        SalesLine."Line No." := NextLineNo;
                        SalesLine.Insert(true);

                        SalesLine.Type := SalesLine.Type::Item;
                        SalesLine.Validate("No.", DoRLine."Item No.");
                        SalesLine.Validate(Quantity, DoRLine.Quantity);
                        SalesLine.Validate("NTS Lot Number", DoRLine."Lot No.");
                        SalesLine.Validate("NTS DOR No.", DoRLine."Document No.");
                        SalesLine.Validate("NTS DOR Line No.", DoRLine."Line No.");
                        SalesLine.Validate("Location Code", SelectedDoRHeaders."Location Code");
                        SalesLine.Validate("NTS Surgeon", SelectedDoRHeaders.Surgeon);
                        SalesLine.Validate("NTS Distributor", SelectedDoRHeaders.Distributor);
                        SalesLine.Validate("NTS Reps.", SelectedDoRHeaders."Reps.");
                        SalesLine.Validate("NTS Reps. Name", SelectedDoRHeaders."Reps. Name");
                        SalesLine.Validate("NTS Set Name", SelectedDoRHeaders."Set Name");
                        SalesLine.Validate("NTS Set Lot No.", SelectedDoRHeaders."Lot No.");
                        SalesLine.Validate("NTS Set Serial No.", SelectedDoRHeaders."Serial No.");
                        SalesLine.Modify(true);

                        ItemTrackingVal := FindItemTrackingCode(SalesLine."No.");
                        if (ItemTrackingVal <> 0) then begin

                            ForReservEntry."Lot No." := DoRLine."Lot No.";
                            TrackingSpec."New Lot No." := DoRLine."Lot No.";

                            CreateReservEntry.CreateReservEntryFor(
                            Database::"Sales Line", 1,
                            SalesLine."Document No.", '',
                            0, SalesLine."Line No.",
                            SalesLine."Qty. per Unit of Measure", SalesLine.Quantity, SalesLine."Quantity (Base)",
                            ForReservEntry);
                            CreateReservEntry.SetNewTrackingFromNewTrackingSpecification(TrackingSpec);
                            CreateReservEntry.CreateEntry(
                            SalesLine."No.", SalesLine."Variant Code",
                            SalesLine."Location Code", SalesLine.Description,
                            0D, SalesLine."Shipment Date",
                            0, ForReservEntry."Reservation Status"::Surplus);
                        end;
                    until DoRLine.Next() = 0;

                SelectedDoRHeaders.Posted := true;
                SelectedDoRHeaders.Modify();

                PrevCustNo := SelectedDoRHeaders."Customer No.";
                PrevLocation := SelectedDoRHeaders."Location Code";
            until SelectedDoRHeaders.Next() = 0;

        if SalesOrderCreated then
            Message(SalesOrderscreatedsuccessfullyMsg)
        else
            Error(NothingtoUpdateErrMsg);
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
            SalesReceivablesSetup."NTS DOR Journal Batch Name", ItemJournalLine."Journal Batch Name",
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
                    SalesReceivablesSetup."NTS DOR Journal Batch Name", ItemJournalLine."Journal Batch Name",
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
        LocationRec.SetRange("NTS Is Finished Goods Location", true);
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

                if not DORLine.get(SalesLine."NTS DOR No.", SalesLine."NTS DOR Line No.") then
                    exit;

                ItemTrackingVal := FindItemTrackingCode(ItemJournalLine."Item No.");
                if (ItemTrackingVal <> 0) then begin
                    ForReservEntry."Lot No." := DoRLine."Lot No.";
                    TrackingSpec."New Lot No." := DoRLine."Lot No.";

                    CreateReservEntry.CreateReservEntryFor(
                    Database::"Item Journal Line", 2,
                    SalesReceivablesSetup."NTS DOR Journal Batch Name", ItemJournalLine."Journal Batch Name",
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
        DORHeader: Record "NTS DOR Header";
        ItemTrackingMgmt: Codeunit "Item Tracking Management";
        ReservationEntry: Record "Reservation Entry";
        Direction: Enum "Transfer Direction";
        Item: Record Item;
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
        DORHeader.Get(AssemblyHeader."NTS DOR No.");
        AssemblyHeader.Validate(Quantity, DORHeader.Quantity);
        AssemblyHeader.Modify(true);
        //Creating tracking for Assembly Item
        ItemTrackingVal := FindItemTrackingCode(AssemblyHeader."Item No.");
        if (ItemTrackingVal <> 0) then begin
            ForReservEntry."Lot No." := DORHeader."Serial No.";
            TrackingSpec."New Lot No." := DORHeader."Serial No.";

            CreateReservEntry.CreateReservEntryFor(
            Database::"Assembly Header", 1,
            AssemblyHeader."No.", '',
            0, 0,
            AssemblyHeader."Qty. per Unit of Measure", AssemblyHeader.Quantity, AssemblyHeader."Quantity (Base)",
            ForReservEntry);
            CreateReservEntry.SetNewTrackingFromNewTrackingSpecification(TrackingSpec);
            CreateReservEntry.CreateEntry(
            AssemblyHeader."No.", AssemblyHeader."Variant Code",
            AssemblyHeader."Location Code", AssemblyHeader.Description,
            0D, AssemblyHeader."Due Date",
            0, ForReservEntry."Reservation Status"::Surplus);
        end;

        AssemblyLine.Reset();
        AssemblyLine.SetRange("Document No.", AssemblyHeader."No.");
        if AssemblyLine.FindSet() then
            AssemblyLine.DeleteAll(true);

        //Transfer Lines to Assembly
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
                AssemblyLine.Validate("Quantity per", TransLine.Quantity);
                AssemblyLine.Validate("Unit of Measure Code", TransLine."Unit of Measure Code");
                AssemblyLine.Validate("NTS DOR No.", TransLine."NTS DOR No.");
                AssemblyLine.Validate("NTS DOR Line No.", TransLine."NTS DOR Line No.");
                AssemblyLine.Modify(true);
                NextLineNo += 10000;

                // ItemTrackingVal := FindItemTrackingCode(AssemblyLine."No.");
                // if (ItemTrackingVal <> 0) then begin
                //     NTSDORLine.Get(AssemblyLine."NTS DOR No.", AssemblyLine."NTS DOR Line No.");
                //     ForReservEntry."Lot No." := NTSDORLine."Lot No.";
                //     TrackingSpec."New Lot No." := NTSDORLine."Lot No.";

                //     CreateReservEntry.CreateReservEntryFor(
                //     Database::"Assembly Line", 1,
                //     AssemblyLine."Document No.", '',
                //     0, AssemblyLine."Line No.",
                //     AssemblyLine."Qty. per Unit of Measure", AssemblyLine.Quantity, AssemblyLine."Quantity (Base)",
                //     ForReservEntry);
                //     CreateReservEntry.SetNewTrackingFromNewTrackingSpecification(TrackingSpec);
                //     CreateReservEntry.CreateEntry(
                //     AssemblyLine."No.", AssemblyLine."Variant Code",
                //     AssemblyLine."Location Code", AssemblyLine.Description,
                //     0D, AssemblyLine."Due Date",
                //     0, ForReservEntry."Reservation Status"::Surplus);
                // end;

                //Retrieve Tracking Lines for Transfer Line
                Direction := Direction::Inbound;
                ReservationEntry.SetSourceFilter(
                    Database::"Transfer Line", Direction.AsInteger(), TransferHeader."No.", -1, true);
                ReservationEntry.SetRange("Source Batch Name", '');
                if Direction = Direction::Outbound then
                    ReservationEntry.SetRange("Source Prod. Order Line", 0)
                else
                    ReservationEntry.SetFilter("Source Prod. Order Line", '<>%1', 0);
                if ReservationEntry.FindFirst() then begin
                    //processes this to assembly line.
                    ItemTrackingVal := FindItemTrackingCode(AssemblyLine."No.");
                    if (ItemTrackingVal <> 0) then begin

                        ForReservEntry."Lot No." := ReservationEntry."Lot No.";
                        TrackingSpec."New Lot No." := ReservationEntry."Lot No.";

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
                end;
            //ItemJnlPostLine.RunWithCheck(ItemJournalLine);
            until TransLine.Next() = 0;

        //Transfer Non consumed DOR Lines
        NTSDORLine.Reset();
        NTSDORLine.SetRange("Document No.", TransferHeader."NTS DOR No.");
        NTSDORLine.SetRange(Consumed, false);
        if NTSDORLine.FindSet() then
            repeat
                Item.get(NTSDORLine."Item No.");
                AssemblyLine.Init();
                AssemblyLine."Document Type" := AssemblyLine."Document Type"::Order;
                AssemblyLine."Document No." := AssemblyHeader."No.";
                AssemblyLine."Line No." := NextLineNo;
                AssemblyLine.Insert(True);
                AssemblyLine.Validate(Type, AssemblyLine.Type::Item);
                AssemblyLine.Validate("No.", NTSDORLine."Item No.");
                AssemblyLine.Validate(Quantity, NTSDORLine.Quantity);
                AssemblyLine.Validate("Quantity per", NTSDORLine.Quantity);
                AssemblyLine.Validate("NTS DOR No.", NTSDORLine."Document No.");
                AssemblyLine.Validate("NTS DOR Line No.", NTSDORLine."Line No.");
                AssemblyLine.Modify(true);
                NextLineNo += 10000;

                ItemTrackingVal := FindItemTrackingCode(AssemblyLine."No.");
                if (ItemTrackingVal <> 0) then begin
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
            until NTSDORLine.Next() = 0;



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
        Location.SetRange("NTS Is Finished Goods Location", true);
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
        // TransferHeader.Validate("Assigned User ID", SalesHeader."Salesperson Code");
        TransferHeader.Validate("Shipment Date", SalesHeader."Shipment Date");
        TransferHeader.Validate("Shipping Agent Code", SalesHeader."Shipping Agent Code");
        TransferHeader.Validate("Shipping Time", SalesHeader."Shipping Time");
        TransferHeader.Validate("NTS Set Name", SalesHeader."NTS Set Name");
        TransferHeader.Validate("NTS DOR No.", SalesHeader."NTS DOR No.");
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
                TransferLine.Validate("NTS Set Name", SalesLine."NTS Set Name");
                TransferLine.Modify(true);
                if NTSDORLine.Get(TransferLine."NTS DOR No.", TransferLine."NTS DOR Line No.") then begin
                    if NTSDORLine.Consumed then begin
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
        SalesHeader.Validate("NTS Transfer Order Created", true);
        SalesHeader.Modify();
    end;

    procedure CreateTransferOrderforMultipleDoRs(var SalesHeader: Record "Sales Header")
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
        PrevDORNo: Code[20];
        TransferOrderCreated: Boolean;
        NTSDORHeader: Record "NTS DOR Header";
        LinkMgt: Codeunit "Record Link Management";
        RecordLink: Record "Record Link";
        NoteText: Text;
        CreatedTONosTxt: Text;
        TOCount: Integer;
        WDescText: Text;
        ins: InStream;
        outs: OutStream;
        SalesInStr: InStream;
        TransOutStr: OutStream;
    begin
        Clear(PrevDORNo);
        Clear(TransferOrderCreated);
        Clear(CreatedTONosTxt);
        Clear(TOCount);
        Location.Reset;
        Location.SetRange("NTS Is Finished Goods Location", true);
        Location.FindFirst();



        SalesLine.Reset();
        SalesLine.SetCurrentKey("NTS DOR No.", "NTS DOR Line No.", "NTS Set Name");
        SalesLine.SetRange("Document Type", SalesHeader."Document Type");
        SalesLine.SetRange("Document No.", SalesHeader."No.");
        // SalesLine.SetFilter("NTS DOR No.", '<>%1', '');
        SalesLine.SetRange(Type, SalesLine.Type::Item);
        SalesLine.SetFilter("No.", '<>%1', '');
        if SalesLine.FindSet() then
            repeat
                if (PrevDORNo <> SalesLine."NTS DOR No.") or ((SalesLine."NTS DOR No." = '') and (not TransferOrderCreated)) then begin
                    TransferHeader.Init();
                    TransferHeader."No." := '';
                    TransferHeader.Insert(True);

                    TransferHeader.Validate("Transfer-from Code", Location.Code);
                    TransferHeader.Validate("Transfer-to Code", SalesHeader."Location Code");
                    TransferHeader.Validate("Direct Transfer", true);
                    TransferHeader.Validate("Posting Date", WorkDate());
                    TransferHeader.Validate("Shortcut Dimension 1 Code", SalesHeader."Shortcut Dimension 1 Code");
                    TransferHeader.Validate("Shortcut Dimension 2 Code", SalesHeader."Shortcut Dimension 2 Code");
                    //TransferHeader.Validate("Assigned User ID", SalesHeader."Salesperson Code");
                    TransferHeader.Validate("Shipment Date", SalesHeader."Shipment Date");
                    TransferHeader.Validate("Shipping Agent Code", SalesHeader."Shipping Agent Code");
                    TransferHeader.Validate("Shipping Time", SalesHeader."Shipping Time");
                    if SalesLine."NTS DOR No." <> '' then begin
                        TransferHeader.Validate("NTS DOR No.", SalesLine."NTS DOR No.");
                        TransferHeader.Validate("NTS Set Name", SalesLine."NTS Set Name");
                    end;
                    TransferHeader.Validate("NTS Sales Order No.", SalesHeader."No.");
                    SalesHeader.CalcFields("Work Description");
                    //Clear(TransferHeader."NTS Work Description");
                    if SalesHeader."Work Description".HasValue then begin
                        SalesHeader."Work Description".CreateInStream(SalesInStr);
                        TransferHeader."NTS Work Description".CreateOutStream(TransOutStr);
                        CopyStream(TransOutStr, SalesInStr);
                    end;
                    TransferHeader.Modify(true);
                    TransferHeader.Get(TransferHeader."No.");
                    TransferHeader.CalcFields("NTS Work Description");
                    LinkMgt.CopyLinks(SalesHeader, TransferHeader);
                    if CreatedTONosTxt = '' then
                        CreatedTONosTxt := TransferHeader."No."
                    else
                        CreatedTONosTxt += ', ' + TransferHeader."No.";
                    TransferOrderCreated := true;
                    NextLineNo := 0;
                end;

                NextLineNo += 10000;
                TransferLine.Init();
                TransferLine."Document No." := TransferHeader."No.";
                TransferLine."Line No." := NextLineNo;
                TransferLine.Insert(true);

                TransferLine.Validate("Item No.", SalesLine."No.");
                TransferLine.Validate(Quantity, SalesLine.Quantity);
                TransferLine.Validate("Unit of Measure Code", SalesLine."Unit of Measure Code");
                TransferLine.Validate("NTS Sales Order No.", SalesLine."Document No.");
                TransferLine.Validate("NTS Sales Order Line No.", SalesLine."Line No.");
                if SalesLine."NTS DOR No." <> '' then begin
                    TransferLine.Validate("NTS DOR No.", SalesLine."NTS DOR No.");
                    TransferLine.Validate("NTS DOR Line No.", SalesLine."NTS DOR Line No.");
                    TransferLine.Validate("NTS Set Name", SalesLine."NTS Set Name");
                    TransferLine.Validate("NTS Set Serial No.", SalesLine."NTS Set Serial No.");
                end;
                TransferLine.Modify(true);

                /*
                if SalesLine."NTS DOR No." <> '' then begin
                    if NTSDORLine.Get(TransferLine."NTS DOR No.", TransferLine."NTS DOR Line No.") then begin
                        if NTSDORLine.Consumed then begin
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
                end;
                */
                PrevDORNo := SalesLine."NTS DOR No.";
            until SalesLine.Next() = 0;

        if not TransferOrderCreated then
            Error(NothingToUpdateErrMsg);

        SalesHeader.Validate("NTS Transfer Order Created", true);
        SalesHeader.Modify();

        if CreatedTONosTxt <> '' then
            Message(TransferOrderscreatedsuccessfullyMsg, CreatedTONosTxt);
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

    procedure ValidateLOTSerial(ItemTrackingType: Integer; LotNo: Code[50]; SerialNo: Code[20])
    begin
        Case ItemTrackingType of
            0:
                begin
                    if LotNo <> '' then
                        Error('Lot No. must be Blank');
                    if SerialNo <> '' then
                        Error('Serial No. must be Blank');
                end;
            1:
                begin
                    if LotNo = '' then
                        Error('Lot No. cannot be Blank');
                end;
            2:
                begin
                    if SerialNo = '' then
                        Error('Serial No. cannot be Blank');
                end;
            3:
                begin
                    if LotNo = '' then
                        Error('Lot No. cannot be Blank');
                    if SerialNo = '' then
                        Error('Serial No. cannot be Blank');
                end;
        end;
    end;

    procedure InsertNonConsumedItems(DORHeader: Record "NTS DOR Header")
    var
        ItemLedgEntry: Record "Item Ledger Entry";
        ItemLedgEntry2: Record "Item Ledger Entry";
        DORLine: Record "NTS DOR Line";
        DORLine2: Record "NTS DOR Line";
        NextLineNo: Integer;
        ItemTrackingVal: Integer;
        BOMComponentRecLcl: Record "BOM Component";
        QtyPerVarLcl: Integer;
    begin
        DORHeader.TestField(DORHeader."Set Name");
        ItemTrackingVal := FindItemTrackingCode(DORHeader."Set Name");
        ValidateLOTSerial(ItemTrackingVal, DORHeader."Lot No.", DORHeader."Serial No.");
        NextLineNo := 0;
        DORLine.Reset();
        DORLine.SetRange("Document No.", DORHeader."No.");
        // DORLine.SetRange(Consumed, true);
        if DORLine.FindLast() then
            NextLineNo := DORLine."Line No." + 10000;

        ItemLedgEntry.Reset();
        ItemLedgEntry.SetRange("Item No.", DORHeader."Set Name");
        ItemLedgEntry.SetRange("Entry Type", ItemLedgEntry."Entry Type"::"Assembly Output");
        //ItemLedgEntry.SetFilter("Remaining Quantity", '<>%1', 0);
        ItemLedgEntry.SetRange("Lot No.", DORHeader."Lot No.");
        ItemLedgEntry.SetRange("Serial No.", DORHeader."Serial No.");
        if ItemLedgEntry.FindLast() then begin
            ItemLedgEntry2.Reset();
            ItemLedgEntry2.SetRange("Document No.", ItemLedgEntry."Document No.");
            ItemLedgEntry2.SetRange("Entry Type", ItemLedgEntry2."Entry Type"::"Assembly Consumption");
            if ItemLedgEntry2.FindSet() then begin
                repeat
                    //QtyPerVarLcl := ItemLedgEntry2.Quantity / ItemLedgEntry.Quantity;

                    BOMComponentRecLcl.Reset();
                    BOMComponentRecLcl.SetRange("Parent Item No.", ItemLedgEntry."Item No.");
                    BOMComponentRecLcl.SetRange("No.", ItemLedgEntry2."Item No.");
                    if BOMComponentRecLcl.FindFirst() then
                        QtyPerVarLcl := BOMComponentRecLcl."Quantity per";

                    DORLine.Reset();
                    DORLine.SetRange("Document No.", DORHeader."No.");
                    DORLine.SetRange(Consumed, true);
                    DORLine.SetRange("Item No.", ItemLedgEntry2."Item No.");
                    if not DORLine.FindFirst() then begin
                        DORLine2.Init();
                        DORLine2."Document No." := DORHeader."No.";
                        DORLine2."Line No." := NextLineNo;
                        DORLine2.Insert(true);
                        DORLine2.Validate("Item No.", ItemLedgEntry2."Item No.");
                        DORLine2.Validate("Lot No.", ItemLedgEntry2."Lot No.");
                        //DORLine2.Validate(Quantity, ItemLedgEntry2.Quantity);
                        //DORLine2.Validate(Quantity, ItemLedgEntry2."Qty. per Unit of Measure" * DORHeader.Quantity);
                        DORLine2.Validate(Quantity, QtyPerVarLcl * DORHeader.Quantity);
                        DORLine2.Validate(Consumed, false);
                        DORLine2.Modify();
                        NextLineNo += 10000;
                    end;
                until ItemLedgEntry2.Next() = 0;
            end;
        end;
    end;

    procedure GetAndValidateLOTSerialCombo(ItemNo: Code[20]; LotNo: Code[50]; SerialNo: Code[20])
    var
        ItemTrackingVal: Integer;
    begin
        ItemTrackingVal := FindItemTrackingCode(ItemNo);
        ValidateLOTSerial(ItemTrackingVal, LotNo, SerialNo);

    end;

    procedure ApplyPostedDORAdjustments(DORHeaderPar: Record "NTS DOR Header")
    var
        DORLineRecLcl: Record "NTS DOR Line";
        TransHeadRecLcl: Record "Transfer Header";
        TransShptHeadRecLcl: Record "Transfer Shipment Header";
        SalesLineRecLcl: Record "Sales Line";
        DocNoVarLcl: Code[20];
        CreateReservEntry: Codeunit "Create Reserv. Entry";
        ForReservEntry: Record "Reservation Entry";
        TrackingSpec: Record "Tracking Specification";
        ItemTrackingVal: integer;
    begin
        DORLineRecLcl.Reset();
        DORLineRecLcl.SetRange("Document No.", DORHeaderPar."No.");
        DORLineRecLcl.SetRange(Adjustment, true);
        DORLineRecLcl.SetRange("Adjustment Processed", false);
        if not DORLineRecLcl.FindFirst() then
            Error(NothingToUpdateErrMsg);


        TransHeadRecLcl.Reset();
        TransHeadRecLcl.SetRange("NTS DOR No.", DORHeaderPar."No.");
        if TransHeadRecLcl.FindFirst() then
            error(StrSubstNo(ApplyAdjustmentMsg, 'Transfer Order', TransHeadRecLcl."No.", DORHeaderPar."No."));

        TransShptHeadRecLcl.Reset();
        TransShptHeadRecLcl.SetRange("NTS DOR No.", DORHeaderPar."No.");
        if TransShptHeadRecLcl.FindFirst() then
            error(StrSubstNo(ApplyAdjustmentMsg, 'Transfer Order Shipment', TransShptHeadRecLcl."No.", DORHeaderPar."No."));


        SalesLineRecLcl.Reset();
        SalesLineRecLcl.SetRange("NTS DOR No.", DORHeaderPar."No.");
        SalesLineRecLcl.FindFirst();
        DocNoVarLcl := SalesLineRecLcl."Document No.";

        NextLineNo := 0;
        SalesLineRecLcl.Reset();
        SalesLineRecLcl.SetRange("Document Type", SalesLineRecLcl."Document Type"::Order);
        SalesLineRecLcl.SetRange("Document No.", DocNoVarLcl);
        if SalesLineRecLcl.FindLast() then
            NextLineNo := SalesLineRecLcl."Line No.";



        DORLineRecLcl.Reset();
        DORLineRecLcl.SetRange("Document No.", DORHeaderPar."No.");
        DORLineRecLcl.SetRange(Adjustment, true);
        DORLineRecLcl.SetRange("Adjustment Processed", false);
        if DORLineRecLcl.FindSet() then
            repeat
                NextLineNo += 10000;
                SalesLineRecLcl.Init();
                SalesLineRecLcl."Document Type" := SalesLineRecLcl."Document Type"::Order;
                SalesLineRecLcl."Document No." := DocNoVarLcl;
                SalesLineRecLcl."Line No." := NextLineNo;
                SalesLineRecLcl.Insert(true);

                SalesLineRecLcl.Type := SalesLineRecLcl.Type::Item;
                SalesLineRecLcl.Validate("No.", DORLineRecLcl."Item No.");
                SalesLineRecLcl.Validate(Quantity, DORLineRecLcl.Quantity);
                SalesLineRecLcl.Validate("NTS Lot Number", DORLineRecLcl."Lot No.");
                SalesLineRecLcl.Validate("NTS DOR No.", DORLineRecLcl."Document No.");
                SalesLineRecLcl.Validate("NTS DOR Line No.", DORLineRecLcl."Line No.");
                SalesLineRecLcl.Validate("Location Code", DORHeaderPar."Location Code");
                SalesLineRecLcl.Validate("NTS Surgeon", DORHeaderPar.Surgeon);
                SalesLineRecLcl.Validate("NTS Distributor", DORHeaderPar.Distributor);
                SalesLineRecLcl.Validate("NTS Reps.", DORHeaderPar."Reps.");
                SalesLineRecLcl.Validate("NTS Reps. Name", DORHeaderPar."Reps. Name");
                SalesLineRecLcl.Validate("NTS Set Name", DORHeaderPar."Set Name");
                SalesLineRecLcl.Validate("NTS Set Lot No.", DORHeaderPar."Lot No.");
                SalesLineRecLcl.Validate("NTS Set Serial No.", DORHeaderPar."Serial No.");
                SalesLineRecLcl.Modify(true);

                ItemTrackingVal := FindItemTrackingCode(SalesLineRecLcl."No.");
                if (ItemTrackingVal <> 0) then begin

                    ForReservEntry."Lot No." := DORLineRecLcl."Lot No.";
                    TrackingSpec."New Lot No." := DORLineRecLcl."Lot No.";

                    CreateReservEntry.CreateReservEntryFor(
                    Database::"Sales Line", 1,
                    SalesLineRecLcl."Document No.", '',
                    0, SalesLineRecLcl."Line No.",
                    SalesLineRecLcl."Qty. per Unit of Measure", SalesLineRecLcl.Quantity, SalesLineRecLcl."Quantity (Base)",
                    ForReservEntry);
                    CreateReservEntry.SetNewTrackingFromNewTrackingSpecification(TrackingSpec);
                    CreateReservEntry.CreateEntry(
                    SalesLineRecLcl."No.", SalesLineRecLcl."Variant Code",
                    SalesLineRecLcl."Location Code", SalesLineRecLcl.Description,
                    0D, SalesLineRecLcl."Shipment Date",
                    0, ForReservEntry."Reservation Status"::Surplus);
                end;
                DORLineRecLcl."Adjustment Processed" := true;
                DORLineRecLcl.Modify();
            until DORLineRecLcl.Next() = 0;
    end;

    procedure ReadExcelSheet()
    var
        FileMgtCULcl: Codeunit "File Management";
        IStreamVarLcl: InStream;
        FromFileVarLcl: Text[100];
    begin
        UploadIntoStream(UploadExcelMsg, '', '', FromFileVarLcl, IStreamVarLcl);
        if FromFileVarLcl <> '' then begin
            FileNameVarLcl := FileMgtCULcl.GetFileName(FromFileVarLcl);
            SheetNameVarLcl := TempExcelBufferRecGbl.SelectSheetsNameStream(IStreamVarLcl);
        end else
            Error(NoFileFoundMsg);
        TempExcelBufferRecGbl.Reset();
        TempExcelBufferRecGbl.DeleteAll();
        TempExcelBufferRecGbl.OpenBookStream(IStreamVarLcl, SheetNameVarLcl);
        TempExcelBufferRecGbl.ReadSheet();
    end;

    local procedure GetValueAtCell(RowNoVarLcl: Integer; ColNoVarLcl: Integer): Text
    begin

        TempExcelBufferRecGbl.Reset();
        If TempExcelBufferRecGbl.Get(RowNoVarLcl, ColNoVarLcl) then
            exit(TempExcelBufferRecGbl."Cell Value as Text")
        else
            exit('');
    end;

    procedure ImportNotesForSerialNoInfoAndLotNoInfo()
    var
        SerialNoInfoRecLcl: Record "Serial No. Information";
        LotNoInfoRecLcl: Record "Lot No. Information";
        RowNoVarLcl: Integer;
        ColNoVarLcl: Integer;
        MaxRowNoVarLcl: Integer;
        ItemNoVarLcl: Code[20];
        VariantCodeVarLcl: Code[10];
        SerialNoVarLcl: Code[50];
        LotNoVarLcl: Code[50];
        NotesVarLcl: Text;
    begin
        RowNoVarLcl := 0;
        ColNoVarLcl := 0;
        MaxRowNoVarLcl := 0;
        Clear(ItemNoVarLcl);
        Clear(VariantCodeVarLcl);
        CLear(SerialNoVarLcl);
        Clear(LotNoVarLcl);
        Clear(NotesVarLcl);

        TempExcelBufferRecGbl.Reset();
        if TempExcelBufferRecGbl.FindLast() then begin
            MaxRowNoVarLcl := TempExcelBufferRecGbl."Row No.";
        end;
        for RowNoVarLcl := 2 to MaxRowNoVarLcl do begin
            ItemNoVarLcl := GetValueAtCell(RowNoVarLcl, 1);
            VariantCodeVarLcl := GetValueAtCell(RowNoVarLcl, 2);
            SerialNoVarLcl := GetValueAtCell(RowNoVarLcl, 3);
            LotNoVarLcl := GetValueAtCell(RowNoVarLcl, 4);
            NotesVarLcl := GetValueAtCell(RowNoVarLcl, 5);
            if SerialNoVarLcl <> '' then begin
                SerialNoInfoRecLcl.Get(ItemNoVarLcl, VariantCodeVarLcl, SerialNoVarLcl);
                SerialNoInfoRecLcl.SetSerialNoNotes(NotesVarLcl);
            end;
            if LotNoVarLcl <> '' then begin
                LotNoInfoRecLcl.Get(ItemNoVarLcl, VariantCodeVarLcl, LotNoVarLcl);
                LotNoInfoRecLcl.SetLotNoNotes(NotesVarLcl);
            end;
        end;
        Message(ExcelImportSucess);
    end;

    var
        TempExcelBufferRecGbl: Record "Excel Buffer" temporary;
        FileNameVarLcl: Text[100];
        SheetNameVarLcl: Text[100];
        UploadExcelMsg: Label 'Please Choose the Excel file.';
        NoFileFoundMsg: Label 'No Excel file found!';
        ExcelImportSucess: Label 'Excel is successfully imported.';
        SalesReceivablesSetup: Record "Sales & Receivables Setup";
        SalesOrderCreatedandOpenSalesOrderMsg: Label 'Sales Order %1 is successfully created. Do you want to open sales order?';
        NothingToUpdateErrMsg: Label 'There is nothing to update.';
        SalesOrderscreatedsuccessfullyMsg: Label 'Sales Order(s) created successfully';
        TransferOrderscreatedsuccessfullyMsg: Label 'Transfer Order(s)- %1 created successfully';
        ApplyAdjustmentMsg: Label 'Adjusments cannot be applied. There is %1 %2 already created for this No. %3';
}