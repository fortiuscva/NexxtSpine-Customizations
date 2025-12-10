report 52110 "NTS Refresh IR Link"
{
    ApplicationArea = All;
    Caption = 'Refresh IR Link';
    UsageCategory = ReportsAndAnalysis;
    ProcessingOnly = true;
    dataset
    {
        dataitem(ProdOrderRoutingLine; "Prod. Order Routing Line")
        {
            trigger OnAfterGetRecord()
            var
                NewRecLink: Record "Record Link";
            begin
                if RecreateVar then begin
                    if "NTS IR Sheet 1" <> '' then
                        DeleteIRLinkForSheet(ProdOrderRoutingLine, "NTS IR Sheet 1");

                    if "NTS IR Sheet 2" <> '' then
                        DeleteIRLinkForSheet(ProdOrderRoutingLine, "NTS IR Sheet 2");

                    if "NTS IR Sheet 3" <> '' then
                        DeleteIRLinkForSheet(ProdOrderRoutingLine, "NTS IR Sheet 3");
                end;

                if "NTS IR Sheet 1" <> '' then
                    CopyIRCodesToReferenceIRCodes("NTS IR Sheet 1");

                if "NTS IR Sheet 2" <> '' then
                    CopyIRCodesToReferenceIRCodes("NTS IR Sheet 2");

                if "NTS IR Sheet 3" <> '' then
                    CopyIRCodesToReferenceIRCodes("NTS IR Sheet 3");
            end;

        }
    }
    requestpage
    {
        layout
        {
            area(Content)
            {
                group(Options)
                {
                    field(RecreateVar; RecreateVar)
                    {
                        ApplicationArea = all;
                        Caption = 'Recreate';
                    }
                }
            }
        }
    }
    var
        RecreateVar: Boolean;
        SheetName1Gbl: Code[20];
        SheetName2Gbl: Code[20];

        SheetName3Gbl: Code[20];


    local procedure DeleteIRLinkForSheet(ProdOrderRoutingLinepar: Record "Prod. Order Routing Line"; SheetName: Code[20])
    var
        RecLink: Record "Record Link";
        IRCode: Record "NTS IR Code";
        ReferenceIRCode: Record "NTS Reference IR Code";
    begin
        IRCode.Get(SheetName);

        RecLink.Reset();
        if IRCode."IR/IP Type" = IRCode."IR/IP Type"::IR then
            RecLink.SetRange(Description, ProdOrderRoutingLinepar."Prod. Order No." + ',' + IRCode."IR Number")
        else
            RecLink.SetRange(Description, ProdOrderRoutingLinepar."Prod. Order No." + ',' + ProdOrderRoutingLinepar."Operation No." + ',' + IRCode."IR Number");
        if RecLink.FindSet() then
            repeat
                RecLink.Delete();
            until RecLink.Next() = 0;

        //Delete Reference IR code Specific to the Line
        ReferenceIRCode.Reset();
        ReferenceIRCode.SetRange("Source Type", Database::"Prod. Order Routing Line");
        ReferenceIRCode.SetRange("Source Subtype", ProdOrderRoutingLinepar.Status);
        ReferenceIRCode.SetRange("Source No.", ProdOrderRoutingLinepar."Prod. Order No.");
        ReferenceIRCode.SetRange("Source Line No.", ProdOrderRoutingLinepar."Routing Reference No.");
        ReferenceIRCode.SetRange("Source Subline No.", 0);

        if IRCode."IR/IP Type" = IRCode."IR/IP Type"::IP then
            ReferenceIRCode.SetRange("Operation No.", ProdOrderRoutingLinepar."Operation No.");

        ReferenceIRCode.SetRange("IR Number", IRCode."IR Number");
        if ReferenceIRCode.FindSet() then
            ReferenceIRCode.DeleteAll(true);

    end;


    procedure SetSheetName(SheetName1: Code[20]; SheetName2: Code[20]; SheetName3: Code[20])
    begin
        SheetName1Gbl := SheetName1;
        SheetName2Gbl := SheetName2;
        SheetName3Gbl := SheetName3;
    end;


}
