codeunit 52100 "NTS Accrue Sales & Cost Mgmt."
{
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
            CreateAccuredSalesJournals(SalesLine, Format(Month));
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
            CreateAccuredSalesCostJournals(SalesLine, Format(Month));
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
        If not GeneralJournalTemplate.Get(BName + ' ' + Format(MM), '-', Format(YYYY)) then begin
            GeneralJournalTemplate.Init();
            GeneralJournalTemplate.Name := Format(MM) + '-' + Format(YYYY);
            GeneralJournalTemplate.Description := BName + Format(MM) + '-' + Format(YYYY);
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
        If not GeneralJournalBatch.Get(BName + '-' + TemplateName, Format(MM), '-', Format(YYYY)) then begin
            GeneralJournalBatch.Init();
            GeneralJournalBatch."Journal Template Name" := TemplateName;
            GeneralJournalBatch.Name := BName + '-' + Format(MM) + '-' + Format(YYYY);
            GeneralJournalBatch.Description := BName + '-' + Format(MM) + '-' + Format(YYYY);
            GeneralJournalBatch.Insert();
            exit(GeneralJournalBatch.Name);
        end;
        exit(GeneralJournalBatch.Name);
    end;

    local procedure CreateAccuredSalesJournals(salesLine: Record "Sales Line"; Month: Text)
    var
        GeneralJournalLine: Record "Gen. Journal Line";
        SalesSetup: Record "Sales & Receivables Setup";
    begin
        SalesSetup.Get();
        GeneralJournalLine.Init();
        GeneralJournalLine."Journal Template Name" := TemplateName;
        GeneralJournalLine."Journal Batch Name" := BatchName;
        GeneralJournalLine."Line No." := GeneralJournalLine.GetNewLineNo(TemplateName, BatchName);
        GeneralJournalLine.Insert(true);
        GeneralJournalLine."Document Date" := WorkDate();
        GeneralJournalLine."Document No." := 'AR' + salesLine."Document No." + '-' + format(salesLine."Line No.") + '-' + Month;
        GeneralJournalLine.Validate("Account Type", GeneralJournalLine."Account Type"::"G/L Account");
        GeneralJournalLine.Validate("Account No.", SalesSetup."NTS Accrued AR GL");
        GeneralJournalLine.Validate(Amount, salesLine."Outstanding Qty. (Base)" * salesLine."Unit Price");
        GeneralJournalLine.Validate("Bal. Account Type", GeneralJournalLine."Bal. Account Type"::"G/L Account");
        GeneralJournalLine.Validate("Bal. Account No.", SalesSetup."NTS Accrued Sales GL");
        GeneralJournalLine.Insert(true);
    end;

    local procedure CreateAccuredSalesCostJournals(salesLine: Record "Sales Line"; Month: Text)
    var
        GeneralJournalLine: Record "Gen. Journal Line";
        InventrySetup: Record "Inventory Setup";
    begin
        InventrySetup.Get();
        GeneralJournalLine.Init();
        GeneralJournalLine."Journal Template Name" := TemplateName;
        GeneralJournalLine."Journal Batch Name" := BatchName;
        GeneralJournalLine."Line No." := GeneralJournalLine.GetNewLineNo(TemplateName, BatchName);
        GeneralJournalLine.Insert(true);
        GeneralJournalLine."Document Date" := WorkDate();
        GeneralJournalLine."Document No." := 'AC' + salesLine."Document No." + '-' + format(salesLine."Line No.") + '-' + Month;
        GeneralJournalLine.Validate("Account Type", GeneralJournalLine."Account Type"::"G/L Account");
        GeneralJournalLine.Validate("Account No.", InventrySetup."NTS Accrued COGS GL");
        GeneralJournalLine.Validate(Amount, salesLine."Outstanding Qty. (Base)" * salesLine."Unit Cost");
        GeneralJournalLine.Validate("Bal. Account Type", GeneralJournalLine."Bal. Account Type"::"G/L Account");
        GeneralJournalLine.Validate("Bal. Account No.", InventrySetup."NTS Accrued Inventory GL");
        GeneralJournalLine.Insert(true);
    end;

    var
        TemplateName: Code[10];
        BatchName: Code[10];

}
