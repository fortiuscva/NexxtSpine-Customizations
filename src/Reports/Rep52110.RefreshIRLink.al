report 52110 "NTS Refresh IR Link"
{
    ApplicationArea = All;
    Caption = 'Refresh IR Link';
    UsageCategory = ReportsAndAnalysis;
    ProcessingOnly = true;
    dataset
    {
        dataitem("Production Order"; "Production Order")
        {
            RequestFilterFields = "No.";
            DataItemTableView = where(Status = const(Released));
            dataitem(ProdOrderRoutingLine; "Prod. Order Routing Line")
            {
                DataItemLink = "Prod. Order No." = field("No.");

                trigger OnAfterGetRecord()
                var
                    NewRecLink: Record "Record Link";
                begin
                    if "NTS IR Sheet 1" <> '' then
                        CopyIRCodesToReferenceIRCodes("NTS IR Sheet 1");

                    if "NTS IR Sheet 2" <> '' then
                        CopyIRCodesToReferenceIRCodes("NTS IR Sheet 2");

                    if "NTS IR Sheet 3" <> '' then
                        CopyIRCodesToReferenceIRCodes("NTS IR Sheet 3");
                end;

            }

            trigger OnAfterGetRecord()
            begin
                DeleteIRLinkForSheet("Production Order");
            end;
        }
    }
    var
        SheetName1Gbl: Code[20];
        SheetName2Gbl: Code[20];

        SheetName3Gbl: Code[20];


    local procedure DeleteIRLinkForSheet(ProductionOrderRecPar: Record "Production Order")
    var
        RecLink: Record "Record Link";
        IRCode: Record "NTS IR Code";
        ReferenceIRCode: Record "NTS Reference IR Code";
    begin

        RecLink.Reset();
        RecLink.SetRange("Record ID", ProductionOrderRecPar.RecordId);
        if RecLink.FindSet() then
            RecLink.DeleteAll();

        //Delete Reference IR code Specific to the Line
        ReferenceIRCode.Reset();
        ReferenceIRCode.SetRange("Source Type", Database::"Prod. Order Routing Line");
        ReferenceIRCode.SetRange("Source Subtype", ProductionOrderRecPar.Status);
        ReferenceIRCode.SetRange("Source No.", ProductionOrderRecPar."No.");
        if ReferenceIRCode.FindSet() then
            ReferenceIRCode.DeleteAll();

    end;


    procedure SetSheetName(SheetName1: Code[20]; SheetName2: Code[20]; SheetName3: Code[20])
    begin
        SheetName1Gbl := SheetName1;
        SheetName2Gbl := SheetName2;
        SheetName3Gbl := SheetName3;
    end;


}
