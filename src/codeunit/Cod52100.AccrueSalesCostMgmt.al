codeunit 52100 "NTS Accrue Sales & Cost Mgmt."
{


    procedure AccrueSalesRevenueLines(InputDate: Date)
    var
        SalesLine: Record "Sales Line";
        Month: Integer;
    begin
        TemplateName := '';
        BatchName := '';
        TemplateName := CreateAccruedSalesJournalTemplate('AR', InputDate);
        BatchName := CreateAccruedSalesJournalBatch('AR', TemplateName, InputDate);
        Month := Date2DMY(InputDate, 2);
        SalesLine.SetFilter("Qty. to Ship", '<>%1', 0);
        SalesLine.SetFilter("Qty. to Invoice", '<>%1', 0);
        SalesLine.FindSet();
        repeat
            CreateAccuredSalesJournals(SalesLine, Format(Month), InputDate);
            CreateAccuredSalesReversalJournals(SalesLine, Format(Month), CalcDate('1D', InputDate));
        until SalesLine.Next() = 0;
    end;

    procedure AccrueSalesCOGSLines(InputDate: Date)
    var
        SalesLine: Record "Sales Line";
        Month: Integer;
    begin
        TemplateName := '';
        BatchName := '';
        TemplateName := CreateAccruedSalesJournalTemplate('AC', InputDate);
        BatchName := CreateAccruedSalesJournalBatch('AC', TemplateName, InputDate);
        Month := Date2DMY(InputDate, 2);
        SalesLine.SetFilter("Qty. to Ship", '>%1', 0);
        SalesLine.SetFilter("Qty. to Invoice", '>%1', 0);
        SalesLine.FindSet();
        repeat
            CreateAccuredSalesCostJournals(SalesLine, Format(Month), InputDate);
            CreateAccuredSalesCostReversalJournals(SalesLine, Format(Month), CalcDate('1D', InputDate));
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
    begin
        SalesSetup.Get();
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
        GeneralJournalLine.Insert(true);
    end;

    local procedure CreateAccuredSalesReversalJournals(salesLine: Record "Sales Line"; Month: Text; PostingDate: Date)
    var
        GeneralJournalLine: Record "Gen. Journal Line";
        SalesSetup: Record "Sales & Receivables Setup";
        sign: Integer;
    begin
        sign := -1;
        SalesSetup.Get();
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
        GeneralJournalLine.Validate(Amount, sign * (salesLine."Outstanding Qty. (Base)" * salesLine."Unit Price"));
        GeneralJournalLine.Validate("Bal. Account Type", GeneralJournalLine."Bal. Account Type"::"G/L Account");
        GeneralJournalLine.Validate("Bal. Account No.", SalesSetup."NTS Accrued Sales GL");

        GeneralJournalLine.Insert(true);
    end;

    local procedure CreateAccuredSalesCostJournals(salesLine: Record "Sales Line"; Month: Text; PostingDate: Date)
    var
        GeneralJournalLine: Record "Gen. Journal Line";
        InventrySetup: Record "Inventory Setup";
        SourceCodeSetup: Record "Source Code Setup";
    begin
        InventrySetup.Get();
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
        GeneralJournalLine.Insert(true);
    end;

    local procedure CreateAccuredSalesCostReversalJournals(salesLine: Record "Sales Line"; Month: Text; PostingDate: Date)
    var
        GeneralJournalLine: Record "Gen. Journal Line";
        InventrySetup: Record "Inventory Setup";
        SourceCodeSetup: Record "Source Code Setup";
        sign: Integer;
    begin
        sign := -1;
        InventrySetup.Get();
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
        GeneralJournalLine.Validate(Amount, sign * (salesLine."Outstanding Qty. (Base)" * salesLine."Unit Cost"));
        GeneralJournalLine.Validate("Bal. Account Type", GeneralJournalLine."Bal. Account Type"::"G/L Account");
        GeneralJournalLine.Validate("Bal. Account No.", InventrySetup."NTS Accrued Inventory GL");
        GeneralJournalLine.Insert(true);
    end;



    var
        TemplateName: Code[10];
        BatchName: Code[10];

}
