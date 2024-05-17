codeunit 52100 "NTS Accrue Sales & Cost Mgmt."
{
    trigger OnRun()
    begin
        case RunFunction of
            0:
                CreateTransaction();
            1:
                PostTransaction();
        end;
    end;

    procedure AccrueSalesRevenueLines(InputDate: Date)
    var
        SalesLine: Record "Sales Line";
        SalesSetup: Record "Sales & Receivables Setup";
        GeneralJournalLine: Record "Gen. Journal Line";
        Month: Integer;
    begin
        SalesSetup.Get();
        GeneralJournalLine.SetRange("Journal Template Name", SalesSetup."NTS Acc. Sale Gen. Templ. Name");
        GeneralJournalLine.SetRange("Journal Batch Name", SalesSetup."NTS Acc. Sale Gen. Batch Name");
        if GeneralJournalLine.FindSet() then
            GeneralJournalLine.DeleteAll();
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
        InventorSetup: Record "Inventory Setup";
        GeneralJournalLine: Record "Gen. Journal Line";
        Month: Integer;
    begin
        InventorSetup.Get();
        GeneralJournalLine.SetRange("Journal Template Name", InventorSetup."NTS Acc. COST Gen. Templ. Name");
        GeneralJournalLine.SetRange("Journal Batch Name", InventorSetup."NTS Acc. Cost Gen. Batch Name");
        if GeneralJournalLine.FindSet() then
            GeneralJournalLine.DeleteAll();
        Month := Date2DMY(InputDate, 2);
        SalesLine.SetFilter("Qty. to Ship", '>%1', 0);
        SalesLine.SetFilter("Qty. to Invoice", '>%1', 0);
        SalesLine.FindSet();
        repeat
            CreateAccuredSalesCostJournals(SalesLine, Format(Month), InputDate);
            CreateAccuredSalesCostReversalJournals(SalesLine, Format(Month), CalcDate('1D', InputDate));
        until SalesLine.Next() = 0;
    end;


    local procedure CreateAccuredSalesJournals(salesLine: Record "Sales Line"; Month: Text; PostingDate: Date)
    var
        GeneralJournalLine: Record "Gen. Journal Line";
        SalesSetup: Record "Sales & Receivables Setup";
    begin
        SalesSetup.Get();
        SalesSetup.TestField("NTS Accrued AR GL");
        SalesSetup.TestField("NTS Accrued Sales GL");
        SalesSetup.TestField("NTS Acc. Sale Gen. Batch Name");
        SalesSetup.TestField("NTS Acc. Sale Gen. Templ. Name");
        GeneralJournalLine.Init();
        GeneralJournalLine."Journal Template Name" := SalesSetup."NTS Acc. Sale Gen. Templ. Name";
        GeneralJournalLine."Journal Batch Name" := SalesSetup."NTS Acc. Sale Gen. Batch Name";
        GeneralJournalLine."Line No." := GeneralJournalLine.GetNewLineNo(SalesSetup."NTS Acc. Sale Gen. Templ. Name", SalesSetup."NTS Acc. Sale Gen. Batch Name");
        GeneralJournalLine."Document Date" := CalcDate('<CM>', WorkDate());
        GeneralJournalLine.Validate("Posting Date", PostingDate);
        GeneralJournalLine."Document No." := 'Accrued Sale' + format(PostingDate);
        GeneralJournalLine.Validate("Account Type", GeneralJournalLine."Account Type"::"G/L Account");
        GeneralJournalLine.Validate("Account No.", SalesSetup."NTS Accrued AR GL");
        GeneralJournalLine.Validate(Amount, salesLine."Outstanding Qty. (Base)" * salesLine."Unit Price");
        GeneralJournalLine.Validate("Bal. Account Type", GeneralJournalLine."Bal. Account Type"::"G/L Account");
        GeneralJournalLine.Validate("Bal. Account No.", SalesSetup."NTS Accrued Sales GL");
        GeneralJournalLine.Description := 'Accrued Sales' + salesLine."Document No." + '-' + format(salesLine."Line No.") + '-' + Month;
        GeneralJournalLine."Your Reference" := 'ACUUREDSALES';
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
        SalesSetup.TestField("NTS Acc. Sale Gen. Batch Name");
        SalesSetup.TestField("NTS Acc. Sale Gen. Templ. Name");

        GeneralJournalLine.Init();
        GeneralJournalLine."Journal Template Name" := SalesSetup."NTS Acc. Sale Gen. Templ. Name";
        GeneralJournalLine."Journal Batch Name" := SalesSetup."NTS Acc. Sale Gen. Batch Name";
        GeneralJournalLine."Line No." := GeneralJournalLine.GetNewLineNo(SalesSetup."NTS Acc. Sale Gen. Templ. Name", SalesSetup."NTS Acc. Sale Gen. Batch Name");
        GeneralJournalLine."Document Date" := CalcDate('<CM>', WorkDate());
        GeneralJournalLine.Validate("Posting Date", PostingDate);
        GeneralJournalLine."Document No." := 'Accrued Sale' + format(PostingDate);
        GeneralJournalLine.Validate("Account Type", GeneralJournalLine."Account Type"::"G/L Account");
        GeneralJournalLine.Validate("Account No.", SalesSetup."NTS Accrued AR GL");
        GeneralJournalLine.Validate(Amount, sign * (salesLine."Outstanding Qty. (Base)" * salesLine."Unit Price"));
        GeneralJournalLine.Validate("Bal. Account Type", GeneralJournalLine."Bal. Account Type"::"G/L Account");
        GeneralJournalLine.Validate("Bal. Account No.", SalesSetup."NTS Accrued Sales GL");
        GeneralJournalLine.Description := 'Accrued Sales' + salesLine."Document No." + '-' + format(salesLine."Line No.") + '-' + Month;
        GeneralJournalLine."Your Reference" := 'ACUUREDSALES';
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
        InventrySetup.TestField("NTS Acc. COST Gen. Templ. Name");
        InventrySetup.TestField("NTS Acc. Cost Gen. Batch Name");

        GeneralJournalLine.Init();
        GeneralJournalLine."Journal Template Name" := InventrySetup."NTS Acc. COST Gen. Templ. Name";
        GeneralJournalLine."Journal Batch Name" := InventrySetup."NTS Acc. Cost Gen. Batch Name";
        GeneralJournalLine."Line No." := GeneralJournalLine.GetNewLineNo(InventrySetup."NTS Acc. COST Gen. Templ. Name", InventrySetup."NTS Acc. Cost Gen. Batch Name");
        GeneralJournalLine."Document Date" := CalcDate('<CM>', WorkDate());
        GeneralJournalLine.Validate("Posting Date", PostingDate);
        GeneralJournalLine."Document No." := 'Accrued Cost' + format(PostingDate);
        GeneralJournalLine.Validate("Account Type", GeneralJournalLine."Account Type"::"G/L Account");
        GeneralJournalLine.Validate("Account No.", InventrySetup."NTS Accrued COGS GL");
        GeneralJournalLine.Validate(Amount, salesLine."Outstanding Qty. (Base)" * salesLine."Unit Cost");
        GeneralJournalLine.Validate("Bal. Account Type", GeneralJournalLine."Bal. Account Type"::"G/L Account");
        GeneralJournalLine.Validate("Bal. Account No.", InventrySetup."NTS Accrued Inventory GL");
        GeneralJournalLine.Description := 'Accrued Cost' + salesLine."Document No." + '-' + format(salesLine."Line No.") + '-' + Month;
        GeneralJournalLine."Your Reference" := 'ACUUREDSALES';
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
        InventrySetup.TestField("NTS Acc. COST Gen. Templ. Name");
        InventrySetup.TestField("NTS Acc. Cost Gen. Batch Name");

        GeneralJournalLine.Init();
        GeneralJournalLine."Journal Template Name" := InventrySetup."NTS Acc. COST Gen. Templ. Name";
        GeneralJournalLine."Journal Batch Name" := InventrySetup."NTS Acc. Cost Gen. Batch Name";
        GeneralJournalLine."Line No." := GeneralJournalLine.GetNewLineNo(InventrySetup."NTS Acc. COST Gen. Templ. Name", InventrySetup."NTS Acc. Cost Gen. Batch Name");
        GeneralJournalLine."Document Date" := CalcDate('<CM>', WorkDate());
        GeneralJournalLine.Validate("Posting Date", PostingDate);
        GeneralJournalLine."Document No." := 'Accrued Cost' + format(PostingDate);
        GeneralJournalLine.Validate("Account Type", GeneralJournalLine."Account Type"::"G/L Account");
        GeneralJournalLine.Validate("Account No.", InventrySetup."NTS Accrued COGS GL");
        GeneralJournalLine.Validate(Amount, sign * (salesLine."Outstanding Qty. (Base)" * salesLine."Unit Cost"));
        GeneralJournalLine.Validate("Bal. Account Type", GeneralJournalLine."Bal. Account Type"::"G/L Account");
        GeneralJournalLine.Validate("Bal. Account No.", InventrySetup."NTS Accrued Inventory GL");
        GeneralJournalLine."Your Reference" := 'ACUUREDSALES';
        GeneralJournalLine.Description := 'Accrued Cost' + salesLine."Document No." + '-' + format(salesLine."Line No.") + '-' + Month;
        GeneralJournalLine.Insert(true);
    end;

    [TryFunction]
    procedure PostGeneralJournalAccuredRevenue()
    var
        GeneralJournalLine: Record "Gen. Journal Line";
        SalesSetup: Record "Sales & Receivables Setup";
        thisCU: Codeunit "NTS Accrue Sales & Cost Mgmt.";
        GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line";
        EntryNo: Integer;
    begin
        SalesSetup.get();
        TemplateName := SalesSetup."NTS Acc. Sale Gen. Templ. Name";
        BatchName := SalesSetup."NTS Acc. Sale Gen. Batch Name";
        GeneralJournalLine.SetRange("Journal Batch Name", BatchName);
        GeneralJournalLine.SetRange("Journal Template Name", TemplateName);
        if GeneralJournalLine.FindSet() then
            repeat
                if PostJournalLines(GeneralJournalLine) then
                    GeneralJournalLine.Delete();
            until GeneralJournalLine.Next() = 0;
    end;

    [TryFunction]
    procedure PostGeneralJournalAC()
    var
        GeneralJournalLine: Record "Gen. Journal Line";
        InventorySetup: Record "Inventory Setup";
        thisCU: Codeunit "NTS Accrue Sales & Cost Mgmt.";
    begin
        InventorySetup.Get();
        TemplateName := InventorySetup."NTS Acc. COST Gen. Templ. Name";
        BatchName := InventorySetup."NTS Acc. Cost Gen. Batch Name";
        GeneralJournalLine.SetRange("Journal Batch Name", BatchName);
        GeneralJournalLine.SetRange("Journal Template Name", TemplateName);
        if GeneralJournalLine.FindSet() then
            repeat
                if PostJournalLines(GeneralJournalLine) then
                    GeneralJournalLine.Delete();
            until GeneralJournalLine.Next() = 0;
    end;

    [TryFunction]
    local procedure PostJournalLines(var GenJournalLine: Record "Gen. Journal Line")
    var
        GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line";
    begin
        GenJnlPostLine.RunWithCheck(GenJournalLine);
    end;

    local procedure PostTransaction()
    var
    begin
        PostGeneralJournalAC();
        PostGeneralJournalAccuredRevenue();
    end;

    procedure SetRunFunction(FunctionNo: Integer)
    begin
        RunFunction := FunctionNo;
    end;

    local procedure CreateTransaction()
    var
        GLEntry: Record "G/L Entry";
        thisCU: Codeunit "NTS Accrue Sales & Cost Mgmt.";
        InputDate: Date;
    begin
        InputDate := CalcDate('<CM>', WorkDate());
        GLEntry.SetRange(GLEntry."NTS Accured Posting Year", Date2DMY(InputDate, 3));
        GLEntry.SetRange(GLEntry."NTS Accured Posting Month", FORMAT(InputDate, 0, '<Month Text>'));
        if not GLEntry.IsEmpty then
            Error('Posting has alredy been done, please check G/L Entries');

        AccrueSalesRevenueLines(InputDate);
        AccrueSalesCOGSLines(InputDate);
        thisCU.SetRunFunction(1);
        thisCU.Run();
    end;

    var
        RunFunction: Integer;
        TemplateName: Code[10];
        BatchName: Code[10];

}
