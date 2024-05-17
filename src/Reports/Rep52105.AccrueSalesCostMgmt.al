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
            DataItemTableView = WHERE(Number = CONST(1));
            MaxIteration = 1;
            trigger OnPreDataItem()
            begin
                if InputDate = 0D then
                    Error(BlankInputErr);
                AccureSalesCost.AccrueSalesCOGSLines(InputDate);
                AccureSalesCost.AccrueSalesRevenueLines(InputDate);
            end;

            trigger OnPostDataItem()
            begin
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
        InputDate: Date;
        AccureSalesCost: Codeunit "NTS Accrue Sales & Cost Mgmt.";
        ProcessCompletedMsg: Label 'Process has been sucessfully Completed';
        BlankInputErr: Label 'Input Date Must notbe blank';
}
