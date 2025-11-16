report 52108 "Update Location on Assm. Lines"
{
    Caption = 'Update Location on Assembly Lines';
    UsageCategory = None;
    ProcessingOnly = true;
    UseRequestPage = true;

    dataset
    {
        dataitem(AssemblyHeader; "Assembly Header")
        {
            DataItemTableView = sorting("Document Type", "No.");
            dataitem(AssemblyLine; "Assembly Line")
            {
                DataItemLink = "Document No." = field("No.");
                DataItemTableView = sorting("Document Type", "Document No.", "Line No.") where(Type = const(item));

                trigger OnAfterGetRecord()
                begin
                    if LocationCode <> '' then begin
                        if (AssemblyLine."Location Code" <> LocationCode) then begin
                            AssemblyLine.Validate("Location Code", LocationCode);
                            AssemblyLine.Modify(true);
                        end;
                    end;
                end;
            }

            trigger OnPreDataItem()
            begin
                if LocationCode = '' then
                    Error(LocationCannotBeEmptyErrMsg);
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
        LocationCannotBeEmptyErrMsg: Label 'Location Code cannot be empty.';
}
