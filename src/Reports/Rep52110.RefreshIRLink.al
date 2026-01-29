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
                        CopyIRCodesToReferenceIRCodes("NTS IR Sheet 1", false);

                    if "NTS IR Sheet 2" <> '' then
                        CopyIRCodesToReferenceIRCodes("NTS IR Sheet 2", false);

                    if "NTS IR Sheet 3" <> '' then
                        CopyIRCodesToReferenceIRCodes("NTS IR Sheet 3", false);
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
        ManualIRLog: Record "NTS Manual IR Sheet Log";
    begin

        RecLink.Reset();
        RecLink.SetRange("Record ID", ProductionOrderRecPar.RecordId);
        if RecLink.FindSet() then
            RecLink.DeleteAll();

        //Delete Reference IR code Specific to the Line
        // ReferenceIRCode.Reset();
        // ReferenceIRCode.SetRange("Source Type", Database::"Prod. Order Routing Line");
        // ReferenceIRCode.SetRange("Source Subtype", ProductionOrderRecPar.Status);
        // ReferenceIRCode.SetRange("Source No.", ProductionOrderRecPar."No.");
        // if ReferenceIRCode.FindSet() then
        //     ReferenceIRCode.DeleteAll();

        ReferenceIRCode.Reset();
        ReferenceIRCode.SetRange("Source Type", Database::"Prod. Order Routing Line");
        ReferenceIRCode.SetRange("Source Subtype", ProductionOrderRecPar.Status);
        ReferenceIRCode.SetRange("Source No.", ProductionOrderRecPar."No.");

        if ReferenceIRCode.FindSet() then
            repeat
                ManualIRLog.Reset();
                ManualIRLog.SetRange("Source Type", ReferenceIRCode."Source Type");
                ManualIRLog.SetRange("Source Subtype", ReferenceIRCode."Source Subtype");
                ManualIRLog.SetRange("Source No.", ReferenceIRCode."Source No.");
                ManualIRLog.SetRange("Source Line No.", ReferenceIRCode."Source Line No.");
                ManualIRLog.SetRange("Operation No.", ReferenceIRCode."Operation No.");
                ManualIRLog.SetRange("IR Code", ReferenceIRCode.Code);

                if not ManualIRLog.FindFirst() then
                    ReferenceIRCode.Delete();
            until ReferenceIRCode.Next() = 0;

    end;


    procedure SetSheetName(SheetName1: Code[20]; SheetName2: Code[20]; SheetName3: Code[20])
    begin
        SheetName1Gbl := SheetName1;
        SheetName2Gbl := SheetName2;
        SheetName3Gbl := SheetName3;
    end;


}
