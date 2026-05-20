report 52118 "NTS Update Sales Prod Fam"
{
    ApplicationArea = All;
    Caption = 'Update Sales Product Family Summary Data';
    UsageCategory = ReportsAndAnalysis;
    ProcessingOnly = true;

    dataset
    {

        dataitem(SalesLine; "Sales Line")
        {
            DataItemTableView = SORTING("Document Type", "Document No.", "Line No.") WHERE(Type = CONST(Item));

            trigger OnPreDataItem()
            begin
                CurrDocNo := '';
                Clear(FamilyCode);
                Clear(FamilyAmount);
            end;

            trigger OnAfterGetRecord()
            begin
                ProcessSalesLineProdFamily("Document Type", "Document No.", "Shortcut Dimension 1 Code", Amount);
            end;

            trigger OnPostDataItem()
            begin
                InsertProdFamilySummary();
                CurrDocNo := '';
                Clear(FamilyCode);
                Clear(FamilyAmount);
            end;
        }


        dataitem(SalesInvLine; "Sales Invoice Line")
        {
            DataItemTableView = SORTING("Document No.", "Line No.") WHERE(Type = CONST(Item));

            trigger OnPreDataItem()
            begin
                CurrDocNo := '';
                Clear(FamilyCode);
                Clear(FamilyAmount);
            end;

            trigger OnAfterGetRecord()
            begin
                ProcessSalesLineProdFamily(SalesProdFamilySummaryRec."Document Type"::Invoice, "Document No.", "Shortcut Dimension 1 Code", Amount);
            end;

            trigger OnPostDataItem()
            begin
                InsertProdFamilySummary();
                CurrDocNo := '';
                Clear(FamilyCode);
                Clear(FamilyAmount);
            end;
        }
    }


    local procedure ProcessSalesLineProdFamily(DocType: Enum "Sales Document Type"; DocNo: Code[20]; ProdFamily: Code[20]; LineAmount: Decimal)
    begin
        if CurrDocNo <> DocNo then begin
            if CurrDocNo <> '' then
                InsertProdFamilySummary();

            Clear(FamilyCode);
            Clear(FamilyAmount);

            CurrDocNo := DocNo;
            CurrDocType := DocType;
        end;

        AddToFamily(ProdFamily, LineAmount);
    end;


    local procedure AddToFamily(ProdFamily: Code[20]; LineAmount: Decimal)
    var
        i: Integer;
    begin
        if ProdFamily = '' then
            exit;

        for i := 1 to 4 do begin
            if FamilyCode[i] = ProdFamily then begin
                FamilyAmount[i] += LineAmount;
                exit;
            end;
        end;

        for i := 1 to 4 do begin
            if FamilyCode[i] = '' then begin
                FamilyCode[i] := ProdFamily;
                FamilyAmount[i] := LineAmount;
                exit;
            end;
        end;
    end;

    local procedure InsertProdFamilySummary()
    begin
        if CurrDocNo = '' then
            exit;

        SalesProdFamilySummaryRec.Reset();
        SalesProdFamilySummaryRec.SetRange("Document Type", CurrDocType);
        SalesProdFamilySummaryRec.SetRange("Document No.", CurrDocNo);

        if not SalesProdFamilySummaryRec.FindFirst() then begin
            SalesProdFamilySummaryRec.Init();
            SalesProdFamilySummaryRec."Document Type" := CurrDocType;
            SalesProdFamilySummaryRec."Document No." := CurrDocNo;
            SalesProdFamilySummaryRec.Insert();
        end;

        ClearSummaryFields();

        SalesProdFamilySummaryRec."Family 1" := FamilyCode[1];
        SalesProdFamilySummaryRec."Amount 1" := FamilyAmount[1];

        SalesProdFamilySummaryRec."Family 2" := FamilyCode[2];
        SalesProdFamilySummaryRec."Amount 2" := FamilyAmount[2];

        SalesProdFamilySummaryRec."Family 3" := FamilyCode[3];
        SalesProdFamilySummaryRec."Amount 3" := FamilyAmount[3];

        SalesProdFamilySummaryRec."Family 4" := FamilyCode[4];
        SalesProdFamilySummaryRec."Amount 4" := FamilyAmount[4];

        SalesProdFamilySummaryRec.Modify();
    end;

    local procedure ClearSummaryFields()
    begin
        SalesProdFamilySummaryRec."Family 1" := '';
        SalesProdFamilySummaryRec."Amount 1" := 0;

        SalesProdFamilySummaryRec."Family 2" := '';
        SalesProdFamilySummaryRec."Amount 2" := 0;

        SalesProdFamilySummaryRec."Family 3" := '';
        SalesProdFamilySummaryRec."Amount 3" := 0;

        SalesProdFamilySummaryRec."Family 4" := '';
        SalesProdFamilySummaryRec."Amount 4" := 0;
    end;

    var
        CurrDocNo: Code[20];
        CurrDocType: Enum "Sales Document Type";

        FamilyCode: array[4] of Code[20];
        FamilyAmount: array[4] of Decimal;

        SalesProdFamilySummaryRec: Record "Sales Product Family Summary";
}