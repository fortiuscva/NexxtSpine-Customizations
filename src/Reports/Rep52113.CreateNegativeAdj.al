report 52113 "NTS Create Negative Adj."
{
    Caption = 'Create Negative Adjustments';
    UsageCategory = Tasks;
    ApplicationArea = All;
    ProcessingOnly = true;
    Permissions = tabledata "Item Journal Line" = rimd;
    dataset
    {
        dataitem(ItemLedgerEntry; "Item Ledger Entry")
        {
            DataItemTableView = sorting("Item No.", "Location Code", Open, "Posting Date") where(Open = const(true),
                                            "Entry Type" = filter(<> "Negative Adjmt."),
                                            "Remaining Quantity" = filter(> 0));
            RequestFilterFields = "Item No.", "Location Code", "Variant Code", "Posting Date";
            // trigger OnPreDataItem()
            // begin
            //     ItemLedgerEntry.SetLoadFields("Entry No.", "Item No.", "Variant Code", "Location Code", "Unit of Measure Code",
            //                                     "Global Dimension 1 Code", "Global Dimension 2 Code", "Remaining Quantity",
            //                                     Open, "Entry Type", "Posting Date", "Serial No.", "Lot No.");
            // end;

            trigger OnAfterGetRecord()
            var
                ItemRec: Record Item;
                ItemLedgerEntryLclRec: Record "Item Ledger Entry";
            begin
                If (ItemRec.Get("Item No.")) then begin
                    if (ItemRec."Item Tracking Code" = '') then
                        exit;
                    if (ItemRec.Blocked) then
                        exit;
                end;
                if (ItemLedgerEntry."Serial No." = '') and (ItemLedgerEntry."Lot No." = '') then
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
                            ItemJnlBatchPage: Page "Item Journal Batches";
                        begin
                            ItemJnlBatch.SetRange("Journal Template Name", JournalTemplateName);
                            if Page.RunModal(Page::"Item Journal Batches", ItemJnlBatch) = Action::LookupOK then
                                JournalBatchName := ItemJnlBatch.Name;
                        end;
                    }
                }
            }
        }

    }

    trigger OnPreReport()
    begin
        EnsureBatchExists();
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

        ItemJnlLine.Reset();
        ItemJnlLine.SetRange("Journal Template Name", JournalTemplateName);
        ItemJnlLine.SetRange("Journal Batch Name", JournalBatchName);
        if ItemJnlLine.FindLast() then
            NextLineNo := ItemJnlLine."Line No." + 10000
        else
            NextLineNo := 10000;

        ItemJournalLine.Init();
        ItemJournalLine.Validate("Journal Template Name", JournalTemplateName);
        ItemJournalLine.Validate("Journal Batch Name", JournalBatchName);
        ItemJournalLine."Line No." := NextLineNo;
        ItemJournalLine.Insert(true);


        ItemJournalLine.Validate("Entry Type", ItemJournalLine."Entry Type"::"Negative Adjmt.");
        ItemJournalLine.Validate("Item No.", ILE."Item No.");
        ItemJournalLine.Validate("Document No.", ILE."Document No.");
        ItemJournalLine.Validate("Variant Code", ILE."Variant Code");
        ItemJournalLine.Validate("Location Code", ILE."Location Code");
        ItemJournalLine.Validate("Posting Date", Today);
        ItemJournalLine.Validate("Document No.", ILE."Document No.");
        ItemJournalLine.Validate(Description, ILE.Description);

        ItemJournalLine.Validate(Quantity, ILE."Remaining Quantity");
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

    procedure SetInitialValues(JournalTemplateNamePar: Code[10]; JournalBatchNamePar: Code[10])
    begin
        JournalTemplateName := JournalTemplateNamePar;
        JournalBatchName := JournalBatchNamePar;
        PostingDate := Today;
    end;

    var
        JournalTemplateName: Code[10];
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