report 52108 "Update Location on Ass. Lines"
{
    Caption = 'Update Location on Assembly Lines';
    UsageCategory = ReportsAndAnalysis;
    ProcessingOnly = true;
    UseRequestPage = true;
    dataset
    {
        dataitem(AssemblyHeader; "Assembly Header")
        {
            RequestFilterFields = "No.";
            dataitem(AssemblyLine; "Assembly Line")
            {
                DataItemLink = "Document No." = field("No.");

                trigger OnAfterGetRecord()
                begin
                    if LocationCode <> '' then begin
                        AssemblyLine."Location Code" := LocationCode;
                        AssemblyLine.Modify(true);
                    end;
                end;
            }
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
                    field(LocationCode; LocationCode)
                    {
                        ApplicationArea = All;
                        Caption = 'Location Code';
                        TableRelation = Location.Code;
                    }

                }
            }
        }
        trigger OnOpenPage()
        begin
            if AsmHeaderRec."Location Code" = '1021' then
                LocationCode := '1000'
            else
                LocationCode := '';
        end;
    }

    procedure SetAsmHeader(var AssemblyHeaderVar: Record "Assembly Header")
    begin
        AsmHeaderRec := AssemblyHeaderVar;
    end;

    var
        LocationCode: Code[10];
        AsmHeaderRec: Record "Assembly Header";
}
