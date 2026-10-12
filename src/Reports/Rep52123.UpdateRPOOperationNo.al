
report 52123 "NTS Update RPO Operation No."
{
    ApplicationArea = All;
    Caption = 'Update RPO Routing Operation No.';
    UsageCategory = ReportsAndAnalysis;
    ProcessingOnly = true;

    dataset
    {
        dataitem(ProdOrderRoutingLine; "Prod. Order Routing Line")
        {
            RequestFilterFields = Status, "Prod. Order No.";

            trigger OnAfterGetRecord()
            begin
                if ProdOrderRoutingLine."Routing No." = '' then
                    exit;


                if StrLen(ProdOrderRoutingLine."Operation No.") <> 2 then
                    exit;

                TempRoutingLine.Init();
                TempRoutingLine.TransferFields(ProdOrderRoutingLine);
                TempRoutingLine.Insert();
            end;
        }
    }

    trigger OnPostReport()
    var
        RoutingLine: Record "Prod. Order Routing Line";
        OldOperationNo: Code[20];
        NewOperationNo: Code[20];
    begin
        if TempRoutingLine.FindSet() then
            repeat
                OldOperationNo := TempRoutingLine."Operation No.";
                NewOperationNo := '0' + OldOperationNo;

                if RoutingLine.Get(
                    TempRoutingLine.Status,
                    TempRoutingLine."Prod. Order No.",
                    TempRoutingLine."Routing Reference No.",
                    TempRoutingLine."Routing No.",
                    OldOperationNo)
                then begin
                    UpdatePreviousAndNextOperationNo(
      RoutingLine.Status,
      RoutingLine."Prod. Order No.",
      RoutingLine."Routing Reference No.",
      RoutingLine."Routing No.",
      OldOperationNo,
      NewOperationNo);


                    RoutingLine.Delete(true);
                    RoutingLine.Init();
                    RoutingLine.TransferFields(TempRoutingLine);
                    RoutingLine.Validate("Operation No.", NewOperationNo);
                    RoutingLine.Insert(true);

                    UpdatedCount += 1;
                end;
            until TempRoutingLine.Next() = 0;

        Message(
            '%1 production order routing lines updated.',
            UpdatedCount);
    end;

    local procedure UpdatePreviousAndNextOperationNo(
        Status: Enum "Production Order Status";
        ProdOrderNo: Code[20];
        RoutingReferenceNo: Integer;
        RoutingNo: Code[20];
        OldOperationNo: Code[20];
        NewOperationNo: Code[20])
    var
        RoutingLine: Record "Prod. Order Routing Line";
    begin
        RoutingLine.SetRange(Status, Status);
        RoutingLine.SetRange("Prod. Order No.", ProdOrderNo);
        RoutingLine.SetRange("Routing Reference No.", RoutingReferenceNo);
        RoutingLine.SetRange("Routing No.", RoutingNo);

        if RoutingLine.FindSet(true) then
            repeat
                if RoutingLine."Previous Operation No." = OldOperationNo then
                    RoutingLine."Previous Operation No." := NewOperationNo;

                if RoutingLine."Next Operation No." = OldOperationNo then
                    RoutingLine."Next Operation No." := NewOperationNo;

                RoutingLine.Modify(true);
            until RoutingLine.Next() = 0;
    end;

    var
        TempRoutingLine: Record "Prod. Order Routing Line" temporary;
        UpdatedCount: Integer;
}
