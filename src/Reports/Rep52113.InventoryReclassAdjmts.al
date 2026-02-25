report 52113 "NTS Inventory Reclass Adjmts."
{
    Caption = 'Create Negative Adjustments from Open ILE';
    UsageCategory = Tasks;
    ApplicationArea = All;
    ProcessingOnly = true;
    Permissions = tabledata "Item Journal Line" = rimd;
    dataset
    {
        dataitem(ItemLedgerEntry; "Item Ledger Entry")
        {
            DataItemTableView = sorting("Item No.", "Location Code", Open, "Posting Date") where(Open = const(true), "Entry Type" = filter(<> "Negative Adjmt."));
            RequestFilterFields = "Item No.", "Location Code", "Variant Code", "Posting Date";
            trigger OnPreDataItem()
            begin
                ItemLedgerEntry.SetLoadFields("Entry No.", "Item No.", "Variant Code", "Location Code", "Unit of Measure Code", "Global Dimension 1 Code", "Global Dimension 2 Code", "Remaining Quantity", Open, "Entry Type", "Posting Date");

                if LocationFilter <> '' then
                    ItemLedgerEntry.SetFilter("Location Code", LocationFilter);
            end;

            trigger OnAfterGetRecord()
            var
                ItemRec: Record Item;
            begin
                if ItemLedgerEntry."Remaining Quantity" = 0 then
                    exit;
                If ItemRec.Get("Item No.") and ItemRec.Blocked then
                    exit;
                CreateNegAdjLineForILE(ItemLedgerEntry);
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(content)
            {
                group(TargetBatch)
                {
                    Caption = 'Item Journal';
                    field(JournalTemplateName; JournalTemplateName)
                    {
                        ApplicationArea = All;
                        Caption = 'Journal Template Name';
                        TableRelation = "Item Journal Template".Name;
                        trigger OnValidate()
                        begin
                            if (JournalTemplateName = '') or (JournalTemplateName <> xJournalTemplateName) then
                                JournalBatchName := '';

                            xJournalTemplateName := JournalTemplateName;
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
                            ItemJnlBatchPage: Page "Item Journal Batches";
                        begin
                            ItemJnlBatch.SetRange("Journal Template Name", JournalTemplateName);
                            if Page.RunModal(Page::"Item Journal Batches", ItemJnlBatch) = Action::LookupOK then
                                JournalBatchName := ItemJnlBatch.Name;
                        end;
                    }
                }

                group(Defaults)
                {
                    Caption = 'Defaults';
                    field(PostingDate; PostingDate)
                    {
                        ApplicationArea = All;
                        Caption = 'Posting Date';
                    }
                    field(DocumentNo; DocumentNo)
                    {
                        ApplicationArea = All;
                        Caption = 'Document No.';
                        ToolTip = 'If left blank, posting will assign the Document No. using the Posting No. Series on the Item Journal Batch.';
                    }
                }
            }
        }

        trigger OnOpenPage()
        begin
            JournalTemplateName := '';
            JournalBatchName := '';
        end;
    }

    trigger OnPreReport()
    begin
        EnsureBatchExists();
        NextLineNo := 10000;
        ItemJnlLine.Reset();
        ItemJnlLine.SetRange("Journal Template Name", JournalTemplateName);
        ItemJnlLine.SetRange("Journal Batch Name", JournalBatchName);
        if ItemJnlLine.FindLast() then
            NextLineNo := ItemJnlLine."Line No." + 10000;
    end;

    trigger OnPostReport()
    var
        Msg: Label '%1 journal line(s) created in %2/%3.%4', Comment = '%1=CreatedCount, %2=Template, %3=Batch, %4=Optional error suffix';
        ErrText: Text[100];
    begin
        if ErrorCount > 0 then
            ErrText := StrSubstNo('%1', Format(ErrorCount) + ' line(s) skipped due to validation errors.');

        Message(Msg, CreatedCount, JournalTemplateName, JournalBatchName, ErrText);
    end;

    local procedure EnsureBatchExists()
    begin
        if JournalTemplateName = '' then
            Error('Journal Template Name must be specified.');

        if JournalBatchName = '' then
            Error('Journal Batch Name must be specified.');

        if not ItemJnlBatch.Get(JournalTemplateName, JournalBatchName) then
            Error('Item Journal Batch %1/%2 not found.', JournalTemplateName, JournalBatchName);
    end;

    local procedure CreateNegAdjLineForILE(var ILE: Record "Item Ledger Entry")
    var
        ItemJournalLine: Record "Item Journal Line";
        Qty: Decimal;
    begin
        if ILE."Remaining Quantity" <= 0 then
            exit;

        ItemJournalLine.Init();
        ItemJournalLine.Validate("Journal Template Name", JournalTemplateName);
        ItemJournalLine.Validate("Journal Batch Name", JournalBatchName);
        ItemJournalLine."Line No." := NextLineNo;
        NextLineNo += 10000;
        ItemJournalLine.Insert(true);
        ItemJournalLine.Validate("Entry Type", ItemJournalLine."Entry Type"::"Negative Adjmt.");
        ItemJournalLine.Validate("Item No.", ILE."Item No.");
        ItemJournalLine.Validate("Document No.", ILE."Document No.");
        ItemJournalLine.Validate("Variant Code", ILE."Variant Code");
        ItemJournalLine.Validate("Location Code", ILE."Location Code");
        ItemJournalLine.Validate("Posting Date", ILE."Posting Date");
        ItemJournalLine.Validate("Document No.", ILE."Document No.");
        ItemJournalLine.Validate("Reason Code", ILE."Return Reason Code");
        ItemJournalLine.Validate(Description, ILE.Description);
        Qty := -Abs(ILE."Remaining Quantity");
        ItemJournalLine.Validate(Quantity, Qty);
        ItemJournalLine.Validate("Unit of Measure Code", ILE."Unit of Measure Code");
        ItemJournalLine.Validate("Shortcut Dimension 1 Code", ILE."Global Dimension 1 Code");
        ItemJournalLine.Validate("Shortcut Dimension 2 Code", ILE."Global Dimension 2 Code");

        ItemJournalLine.Modify(true);
        ItemTrackingVal := NexxtSpineFunctionsCU.FindItemTrackingCode(ItemJournalLine."Item No.");
        if (ItemTrackingVal <> 0) then begin
            if ItemTrackingVal = 2 then begin
                ForReservEntry."Serial No." := ILE."Serial No.";
                TrackingSpec."New Serial No." := ILE."Serial No.";
                TrackingSpec."Expiration Date" := ILE."Expiration Date";
            end else begin
                ForReservEntry."Lot No." := ILE."Lot No.";
                ForReservEntry."Serial No." := ILE."Serial No.";
                TrackingSpec."New Lot No." := ILE."Lot No.";
                TrackingSpec."New Serial No." := ILE."Serial No.";
                TrackingSpec."Expiration Date" := ILE."Expiration Date";
            end;
            CreateReservEntry.CreateReservEntryFor(
            Database::"Item Journal Line", 3,
            JournalTemplateName, JournalBatchName,
            0, ItemJournalLine."Line No.",
            ItemJournalLine."Qty. per Unit of Measure", ItemJournalLine.Quantity, ItemJournalLine."Quantity (Base)",
            ForReservEntry);
            CreateReservEntry.SetNewTrackingFromNewTrackingSpecification(TrackingSpec);
            CreateReservEntry.CreateEntry(
            ItemJournalLine."Item No.", ItemJournalLine."Variant Code",
            ItemJournalLine."Location Code", ItemJournalLine.Description,
            0D, ItemJournalLine."Posting Date",
            0, ForReservEntry."Reservation Status"::Prospect);
        end;
        CreatedCount += 1;
    end;

    var
        JournalTemplateName: Code[10];
        xJournalTemplateName: Code[10];
        JournalBatchName: Code[10];
        PostingDate: Date;
        DocumentNo: Code[20];
        ReasonCode: Code[10];
        LocationFilter: Code[10];
        DescriptionText: Text[100];
        ClearExisting: Boolean;
        ItemJnlLine: Record "Item Journal Line";
        ItemJnlBatch: Record "Item Journal Batch";
        NextLineNo: Integer;
        CreatedCount: Integer;
        ErrorCount: Integer;
        CreateReservEntry: Codeunit "Create Reserv. Entry";
        ForReservEntry: Record "Reservation Entry";
        TrackingSpec: Record "Tracking Specification";
        ItemTrackingVal: integer;
        NexxtSpineFunctionsCU: Codeunit "NTS NexxtSpine Functions";
}