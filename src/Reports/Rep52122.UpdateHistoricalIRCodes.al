report 52122 "NTS Update Historical IR Codes"
{
    Caption = 'Update Historical IR Codes';
    UsageCategory = Tasks;
    ApplicationArea = All;
    ProcessingOnly = true;

    dataset
    {
        dataitem(ProdOrderRoutingLine; "Prod. Order Routing Line")
        {
            RequestFilterFields = "Prod. Order No.", Status, "Routing No.";

            trigger OnAfterGetRecord()
            var
                RoutingLine: Record "Routing Line";
                ManualIRLog: Record "NTS Manual IR Sheet Log";
            begin
                RoutingLine.SetRange("Routing No.", ProdOrderRoutingLine."Routing No.");
                RoutingLine.SetRange("Operation No.", ProdOrderRoutingLine."Operation No.");
                if RoutingLine.FindFirst() then begin
                    if RoutingLine."NTS IR Sheet 1" <> '' then
                        ProdOrderRoutingLine.CopyIRCodesToReferenceIRCodes(RoutingLine."NTS IR Sheet 1", false);

                    if RoutingLine."NTS IR Sheet 2" <> '' then
                        ProdOrderRoutingLine.CopyIRCodesToReferenceIRCodes(RoutingLine."NTS IR Sheet 2", false);

                    if RoutingLine."NTS IR Sheet 3" <> '' then
                        ProdOrderRoutingLine.CopyIRCodesToReferenceIRCodes(RoutingLine."NTS IR Sheet 3", false);

                    ProdOrderRoutingLine."NTS IR Sheet 1" := RoutingLine."NTS IR Sheet 1";
                    ProdOrderRoutingLine."NTS IR Sheet 2" := RoutingLine."NTS IR Sheet 2";
                    ProdOrderRoutingLine."NTS IR Sheet 3" := RoutingLine."NTS IR Sheet 3";

                    ProdOrderRoutingLine.Modify(true);

                    ProcessedCount += 1;
                end;
            end;

            trigger OnPreDataItem()
            begin
                ProcessedCount := 0;
            end;
        }
    }

    requestpage
    {
        SaveValues = true;
    }


    trigger OnPostReport()
    begin
        Message(
            'Historical IR code update completed. Records processed: %1', ProcessedCount);
    end;

    var
        ProcessedCount: Integer;
}