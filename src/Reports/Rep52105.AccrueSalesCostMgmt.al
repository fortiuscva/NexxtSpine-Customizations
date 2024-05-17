report 52105 "NTS Accrue Sales Cost Mgmt"
{
    Caption = 'Accrue Sales Cost Mgmt';
    ApplicationArea = all;
    ProcessingOnly = true;
    UsageCategory = Administration;
    dataset
    {
        dataitem(Integer; "Integer")
        {
            DataItemTableView = SORTING(Number) ORDER(Ascending) WHERE(Number = CONST(1));
            MaxIteration = 1;
            trigger OnPreDataItem()
            begin
                if InputDate = 0D then
                    Error(BlankInputErr);
                GLEntry.SetRange(GLEntry."NTS Accured Posting Year", Date2DMY(InputDate, 3));
                GLEntry.SetRange(GLEntry."NTS Accured Posting Month", FORMAT(InputDate, 0, '<Month Text>'));
                if not GLEntry.IsEmpty then
                    Error('Posting has alredy been done, please check G/L Entries');
                AccureSalesCost.AccrueSalesCOGSLines(InputDate);
                AccureSalesCost.AccrueSalesRevenueLines(InputDate);
            end;

            trigger OnPostDataItem()
            begin
                if GuiAllowed then
                    Message(ProcessCompletedMsg);
            end;
        }
    }
    requestpage
    {
        layout
        {
            area(content)
            {
                group(Input)
                {
                    Caption = 'Input Data';
                    field(InputDate; InputDate)
                    {
                        ApplicationArea = all;
                        Caption = 'Enter Date';
                        trigger OnValidate()

                        begin
                            InputDate := CalcDate('<CM>', WorkDate());
                        end;
                    }

                }
            }
        }

    }
    var
        GLEntry: Record "G/L Entry";
        InputDate: Date;
        AccureSalesCost: Codeunit "NTS Accrue Sales & Cost Mgmt.";
        ProcessCompletedMsg: Label 'General Journal Entries has Created Sucessfully.';
        BlankInputErr: Label 'Input Date Must not be blank';
}
