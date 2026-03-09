report 52113 "NTS Create Negative Adj."
{
    Caption = 'Create Negative Adjustments';
    UsageCategory = Tasks;
    ApplicationArea = All;
    ProcessingOnly = true;

    Permissions = tabledata "Item Journal Line" = rimd;

    requestpage
    {
        layout
        {
            area(content)
            {
                group(TargetBatch)
                {
                    field(JournalTemplateName; JournalTemplateName)
                    {
                        ApplicationArea = All;
                        Caption = 'Journal Template Name';
                        TableRelation = "Item Journal Template".Name;

                        trigger OnValidate()
                        begin
                            if JournalBatchName <> '' then
                                Clear(JournalBatchName);
                        end;
                    }

                    field(JournalBatchName; JournalBatchName)
                    {
                        ApplicationArea = All;
                        Caption = 'Journal Batch Name';
                        Lookup = true;

                        trigger OnLookup(var Text: Text): Boolean
                        var
                            ItemJnlBatch: Record "Item Journal Batch";
                        begin
                            ItemJnlBatch.SetRange("Journal Template Name", JournalTemplateName);

                            if Page.RunModal(Page::"Item Journal Batches", ItemJnlBatch) = Action::LookupOK then
                                JournalBatchName := ItemJnlBatch.Name;
                        end;
                    }
                    field(LocationCode; LocationCode)
                    {
                        ApplicationArea = All;
                        Caption = 'Location Code';
                        TableRelation = Location.Code;
                    }
                }
            }
        }
    }

    trigger OnPostReport()
    var
        ILEQuery: Query "NTS ILE Grouped";
    begin
        EnsureBatchExists();

        DocumentNo := 'NA' + Format(Today, 0, '<Year4><Month,2><Day,2>');
        if LocationCode <> '' then
            ILEQuery.SetRange(LocationCode, LocationCode);
        ILEQuery.Open();
        while ILEQuery.Read() do begin

            if not TryCreateNegativeAdjustment(
                ILEQuery.ItemNo,
                ILEQuery.LocationCode,
                ILEQuery.VariantCode,
                ILEQuery.LotNo,
                ILEQuery.SerialNo,
                ILEQuery.RemainingQty,
                ILEQuery.UOM,
                ILEQuery.Dim1,
                ILEQuery.Dim2,
                ILEQuery.ExpirationDate)
            then
                ErrorCount += 1;

        end;

        ILEQuery.Close();

        Message(
            '%1 journal line(s) created. %2 line(s) skipped due to validation errors.',
            CreatedCount,
            ErrorCount);
    end;


    [TryFunction]
    local procedure TryCreateNegativeAdjustment(
        ItemNo: Code[20];
        LocationCode: Code[10];
        VariantCode: Code[10];
        LotNo: Code[50];
        SerialNo: Code[50];
        Qty: Decimal;
        UOM: Code[10];
        Dim1: Code[20];
        Dim2: Code[20];
        ExpDate: Date)
    begin


        GetNextLineNo();

        ItemJnlLine.Init();
        ItemJnlLine.Validate("Journal Template Name", JournalTemplateName);
        ItemJnlLine.Validate("Journal Batch Name", JournalBatchName);
        ItemJnlLine."Line No." := NextLineNo;

        ItemJnlLine.Insert(true);

        ItemJnlLine.Validate("Entry Type", ItemJnlLine."Entry Type"::"Negative Adjmt.");
        ItemJnlLine.Validate("Document No.", DocumentNo);
        ItemJnlLine.Validate("Item No.", ItemNo);
        ItemJnlLine.Validate("Variant Code", VariantCode);
        ItemJnlLine.Validate("Location Code", LocationCode);
        ItemJnlLine.Validate("Posting Date", Today);

        ItemJnlLine.Validate(Quantity, Qty);
        ItemJnlLine.Validate("Unit of Measure Code", UOM);

        ItemJnlLine.Validate("Shortcut Dimension 1 Code", Dim1);
        ItemJnlLine.Validate("Shortcut Dimension 2 Code", Dim2);

        ItemJnlLine.Modify(true);

        CreateTracking(
            ItemJnlLine,
            LotNo,
            SerialNo,
            ExpDate);

        CreatedCount += 1;
    end;


    local procedure CreateTracking(
        ItemJnlLine: Record "Item Journal Line";
        LotNo: Code[50];
        SerialNo: Code[50];
        ExpDate: Date)
    begin

        Clear(ForReservEntry);
        Clear(TrackingSpec);

        if SerialNo <> '' then begin
            ForReservEntry."Serial No." := SerialNo;
            TrackingSpec."New Serial No." := SerialNo;
        end;

        if LotNo <> '' then begin
            ForReservEntry."Lot No." := LotNo;
            TrackingSpec."New Lot No." := LotNo;
        end;

        TrackingSpec."Expiration Date" := ExpDate;

        CreateReservEntry.CreateReservEntryFor(
            Database::"Item Journal Line",
            3,
            ItemJnlLine."Journal Template Name",
            ItemJnlLine."Journal Batch Name",
            0,
            ItemJnlLine."Line No.",
            ItemJnlLine."Qty. per Unit of Measure",
            ItemJnlLine.Quantity,
            ItemJnlLine."Quantity (Base)",
            ForReservEntry);

        CreateReservEntry.SetNewTrackingFromNewTrackingSpecification(TrackingSpec);

        CreateReservEntry.CreateEntry(
            ItemJnlLine."Item No.",
            ItemJnlLine."Variant Code",
            ItemJnlLine."Location Code",
            ItemJnlLine.Description,
            0D,
            ItemJnlLine."Posting Date",
            0,
            ForReservEntry."Reservation Status"::Prospect);
    end;


    local procedure GetNextLineNo()
    begin
        ItemJnlLine.Reset();
        ItemJnlLine.SetRange("Journal Template Name", JournalTemplateName);
        ItemJnlLine.SetRange("Journal Batch Name", JournalBatchName);

        if ItemJnlLine.FindLast() then
            NextLineNo := ItemJnlLine."Line No." + 10000
        else
            NextLineNo := 10000;
    end;


    local procedure EnsureBatchExists()
    begin
        if not ItemJnlBatch.Get(JournalTemplateName, JournalBatchName) then
            Error('Item Journal Batch %1 / %2 not found.', JournalTemplateName, JournalBatchName);
    end;


    procedure SetInitialValues(JournalTemplateNamePar: Code[10]; JournalBatchNamePar: Code[10])
    begin
        JournalTemplateName := JournalTemplateNamePar;
        JournalBatchName := JournalBatchNamePar;
    end;


    var
        JournalTemplateName: Code[10];
        JournalBatchName: Code[10];
        DocumentNo: Code[20];

        ItemJnlLine: Record "Item Journal Line";
        ItemJnlBatch: Record "Item Journal Batch";

        CreateReservEntry: Codeunit "Create Reserv. Entry";

        ForReservEntry: Record "Reservation Entry";
        TrackingSpec: Record "Tracking Specification";

        NextLineNo: Integer;
        CreatedCount: Integer;
        ErrorCount: Integer;
        LocationCode: Code[100];
}