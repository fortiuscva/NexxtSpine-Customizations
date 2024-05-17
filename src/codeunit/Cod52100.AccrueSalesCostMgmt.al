codeunit 52100 "NTS Accrue Sales & Cost Mgmt."
{
    trigger OnRun()
    var
        AccureSalesOrderLines: Record "NTS Accrue Sales Order Lines";
        thisCU: Codeunit "NTS Accrue Sales & Cost Mgmt.";
    begin
        case RunFunction of
            0:
                Start();
            1:
                ReverseTransaction();
        end;
    end;

    procedure AccrueSalesRevenueLines(SalesAcureCost: Record "NTS Accrue Sales Order Lines")
    var
        SalesLine: Record "Sales Line";
        Month: Integer;
    begin
        TemplateName := '';
        BatchName := '';
        TemplateName := CreateAccruedSalesJournalTemplate('AR', SalesAcureCost.Date);
        BatchName := CreateAccruedSalesJournalBatch('AR', TemplateName, SalesAcureCost.Date);
        Month := Date2DMY(SalesAcureCost.Date, 2);
        SalesLine.SetFilter("Qty. to Ship", '<>%1', 0);
        SalesLine.SetFilter("Qty. to Invoice", '<>%1', 0);
        SalesLine.FindSet();
        repeat
            CreateAccuredSalesJournals(SalesLine, Format(Month), SalesAcureCost.Date);
        until SalesLine.Next() = 0;
    end;

    procedure AccrueSalesCOGSLines(SalesAcureCost: Record "NTS Accrue Sales Order Lines")
    var
        SalesLine: Record "Sales Line";
        Month: Integer;
    begin
        TemplateName := '';
        BatchName := '';
        TemplateName := CreateAccruedSalesJournalTemplate('AC', SalesAcureCost.Date);
        BatchName := CreateAccruedSalesJournalBatch('AC', TemplateName, SalesAcureCost.Date);
        Month := Date2DMY(SalesAcureCost.Date, 2);
        SalesLine.SetFilter("Qty. to Ship", '<>%1', 0);
        SalesLine.SetFilter("Qty. to Invoice", '<>%1', 0);
        SalesLine.FindSet();
        repeat
            CreateAccuredSalesCostJournals(SalesLine, Format(Month), SalesAcureCost.Date);
        until SalesLine.Next() = 0;
    end;

    local procedure CreateAccruedSalesJournalTemplate(BName: Text[2]; DateSelected: Date): Code[10]
    var
        GeneralJournalTemplate: Record "Gen. Journal Template";
        MM: Integer;
        YYYY: Integer;
    begin
        MM := Date2DMY(DateSelected, 2);
        YYYY := Date2DMY(DateSelected, 3);
        If not GeneralJournalTemplate.Get(BName + '-' + Format(MM) + '-' + Format(YYYY)) then begin
            GeneralJournalTemplate.Init();
            GeneralJournalTemplate.Name := BName + '-' + Format(MM) + '-' + Format(YYYY);
            GeneralJournalTemplate.Description := BName + '-' + Format(MM) + '-' + Format(YYYY);
            GeneralJournalTemplate.Insert();
            exit(GeneralJournalTemplate.Name);
        end;
        exit(GeneralJournalTemplate.Name);
    end;

    local procedure CreateAccruedSalesJournalBatch(BName: Text[2]; TemplateName: Code[10]; DateSelected: Date): Code[10]
    var
        GeneralJournalTemplate: Record "Gen. Journal Template";
        GeneralJournalBatch: Record "Gen. Journal Batch";
        MM: Integer;
        YYYY: Integer;
    begin
        MM := Date2DMY(DateSelected, 2);
        YYYY := Date2DMY(DateSelected, 3);
        If not GeneralJournalBatch.Get(TemplateName, BName + '-' + Format(MM) + '-' + Format(YYYY)) then begin
            GeneralJournalBatch.Init();
            GeneralJournalBatch."Journal Template Name" := TemplateName;
            GeneralJournalBatch.Name := BName + '-' + Format(MM) + '-' + Format(YYYY);
            GeneralJournalBatch.Description := BName + '-' + Format(MM) + '-' + Format(YYYY);
            GeneralJournalBatch.Insert();
            exit(GeneralJournalBatch.Name);
        end;
        exit(GeneralJournalBatch.Name);
    end;

    local procedure CreateAccuredSalesJournals(salesLine: Record "Sales Line"; Month: Text; PostingDate: Date)
    var
        GeneralJournalLine: Record "Gen. Journal Line";
        SalesSetup: Record "Sales & Receivables Setup";
        SourceCodeSetup: Record "Source Code Setup";
    begin
        SalesSetup.Get();
        SourceCodeSetup.Get();
        SourceCodeSetup.TestField("NTS Accure Sales Source Code");
        SalesSetup.TestField("NTS Accrued AR GL");
        SalesSetup.TestField("NTS Accrued Sales GL");
        GeneralJournalLine.Init();
        GeneralJournalLine."Journal Template Name" := TemplateName;
        GeneralJournalLine."Journal Batch Name" := BatchName;
        GeneralJournalLine."Line No." := GeneralJournalLine.GetNewLineNo(TemplateName, BatchName);
        GeneralJournalLine."Document Date" := WorkDate();
        GeneralJournalLine.Validate("Posting Date", PostingDate);
        GeneralJournalLine."Document No." := 'AR' + salesLine."Document No." + '-' + format(salesLine."Line No." / 10000) + '-' + Month;
        GeneralJournalLine.Validate("Account Type", GeneralJournalLine."Account Type"::"G/L Account");
        GeneralJournalLine.Validate("Account No.", SalesSetup."NTS Accrued AR GL");
        GeneralJournalLine.Validate(Amount, salesLine."Outstanding Qty. (Base)" * salesLine."Unit Price");
        GeneralJournalLine.Validate("Bal. Account Type", GeneralJournalLine."Bal. Account Type"::"G/L Account");
        GeneralJournalLine.Validate("Bal. Account No.", SalesSetup."NTS Accrued Sales GL");
        GeneralJournalLine."Source Code" := SourceCodeSetup."NTS Accure Sales Source Code";
        GeneralJournalLine.Insert(true);
    end;


    local procedure CreateAccuredSalesCostJournals(salesLine: Record "Sales Line"; Month: Text; PostingDate: Date)
    var
        GeneralJournalLine: Record "Gen. Journal Line";
        InventrySetup: Record "Inventory Setup";
        SourceCodeSetup: Record "Source Code Setup";
    begin
        InventrySetup.Get();
        SourceCodeSetup.Get();
        SourceCodeSetup.TestField("NTS Accure Sales Source Code");
        InventrySetup.TestField("NTS Accrued COGS GL");
        InventrySetup.TestField("NTS Accrued Inventory GL");
        GeneralJournalLine.Init();
        GeneralJournalLine."Journal Template Name" := TemplateName;
        GeneralJournalLine."Journal Batch Name" := BatchName;
        GeneralJournalLine."Line No." := GeneralJournalLine.GetNewLineNo(TemplateName, BatchName);
        GeneralJournalLine."Document Date" := WorkDate();
        GeneralJournalLine.Validate("Posting Date", PostingDate);
        GeneralJournalLine."Document No." := 'AC' + salesLine."Document No." + '-' + format(salesLine."Line No." / 10000) + '-' + Month;
        GeneralJournalLine.Validate("Account Type", GeneralJournalLine."Account Type"::"G/L Account");
        GeneralJournalLine.Validate("Account No.", InventrySetup."NTS Accrued COGS GL");
        GeneralJournalLine.Validate(Amount, salesLine."Outstanding Qty. (Base)" * salesLine."Unit Cost");
        GeneralJournalLine.Validate("Bal. Account Type", GeneralJournalLine."Bal. Account Type"::"G/L Account");
        GeneralJournalLine.Validate("Bal. Account No.", InventrySetup."NTS Accrued Inventory GL");
        GeneralJournalLine."Source Code" := SourceCodeSetup."NTS Accure Sales Source Code";
        GeneralJournalLine.Insert(true);
    end;

    procedure SetRunFunction(FunctionNo: Integer; var NTSAccuredLines: Record "NTS Accrue Sales Order Lines" temporary)
    begin
        RunFunction := FunctionNo;
        NTSAccuredLinesG.Copy(NTSAccuredLines);
    end;

    local procedure Start()
    var
        SalesAcureCost: Record "NTS Accrue Sales Order Lines";
        thisCU: Codeunit "NTS Accrue Sales & Cost Mgmt.";
    begin
        if SalesAcureCost.FindSet() then
            repeat
                thisCU.SetRunFunction(1, SalesAcureCost);
                if not thisCU.Run() then begin
                    SalesAcureCost."Error Text" := GetLastErrorText();
                    SalesAcureCost.Modify();
                end else
                    SalesAcureCost.Delete();
                COMMIT;
            until SalesAcureCost.Next() = 0;
    end;

    local procedure ReverseTransaction()
    var
        ReversalEntry: Record "Reversal Entry";
    begin
        ReversalEntry.SetHideWarningDialogs();
        ReversalEntry.ReverseTransaction(NTSAccuredLinesG."Entry No.");
    end;

    [TryFunction]
    procedure PostGeneralJournalAR(SalesAcureCost: Record "NTS Accrue Sales Order Lines")
    var
        GeneralJournalLine: Record "Gen. Journal Line";
        thisCU: Codeunit "NTS Accrue Sales & Cost Mgmt.";
        GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line";
        EntryNo: Integer;
    begin
        TemplateName := CreateAccruedSalesJournalTemplate('AR', SalesAcureCost.Date);
        BatchName := CreateAccruedSalesJournalBatch('AR', TemplateName, SalesAcureCost.Date);
        GeneralJournalLine.SetRange("Journal Batch Name", BatchName);
        GeneralJournalLine.SetRange("Journal Template Name", TemplateName);
        if GeneralJournalLine.FindSet() then
            repeat
                if PostJournalLines(GeneralJournalLine) then
                    GeneralJournalLine.Delete();
            until GeneralJournalLine.Next() = 0;
        DeletJournalTemplate(TemplateName);
    end;

    [TryFunction]
    procedure PostGeneralJournalAC(SalesAcureCost: Record "NTS Accrue Sales Order Lines")
    var
        GeneralJournalLine: Record "Gen. Journal Line";
        thisCU: Codeunit "NTS Accrue Sales & Cost Mgmt.";
    begin
        TemplateName := CreateAccruedSalesJournalTemplate('AC', SalesAcureCost.Date);
        BatchName := CreateAccruedSalesJournalBatch('AC', TemplateName, SalesAcureCost.Date);
        GeneralJournalLine.SetRange("Journal Batch Name", BatchName);
        GeneralJournalLine.SetRange("Journal Template Name", TemplateName);
        if GeneralJournalLine.FindSet() then
            repeat
                if PostJournalLines(GeneralJournalLine) then
                    GeneralJournalLine.Delete();
            until GeneralJournalLine.Next() = 0;
        DeletJournalTemplate(TemplateName);
    end;

    [TryFunction]
    local procedure PostJournalLines(var GenJournalLine: Record "Gen. Journal Line")
    var
        GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line";
    begin
        GenJnlPostLine.RunWithCheck(GenJournalLine);
    end;

    local procedure DeletJournalTemplate(TemplateName: Code[10])
    var
        JournalTemplateName: Record "Gen. Journal Template";
    begin
        if JournalTemplateName.Get(TemplateName) then
            JournalTemplateName.Delete(true);
    end;

    local procedure PostReversal()
    var
        myInt: Integer;
    begin

    end;

    var
        NTSAccuredLinesG: Record "NTS Accrue Sales Order Lines" temporary;
        TemplateName: Code[10];
        BatchName: Code[10];
        RunFunction: Integer;

}
