report 52119 "NTS Export Positive Pay"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    ProcessingOnly = true;

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(Options)
                {
                    field(BankAccountNo; BankAccountNo)
                    {
                        ApplicationArea = All;
                        Caption = 'Bank Account No.';
                        TableRelation = "Bank Account";
                    }

                    field(StartDate; StartDate)
                    {
                        ApplicationArea = All;
                        Caption = 'Start Date';
                    }

                    field(EndDate; EndDate)
                    {
                        ApplicationArea = All;
                        Caption = 'End Date';
                    }
                }
            }
        }
    }

    trigger OnPostReport()
    var
        NexxtSpineFunctions: Codeunit "NTS NexxtSpine Functions";
    begin
        if BankAccountNo = '' then
            Error(BankAccountNoErr);
        if StartDate = 0D then
            Error(StartDateErr);
        if EndDate = 0D then
            Error(EndDateErr);

        NexxtSpineFunctions.ExportPositivePay(BankAccountNo, StartDate, EndDate);
    end;

    var
        BankAccountNo: Code[20];
        StartDate: Date;
        EndDate: Date;
        BankAccountNoErr: Label 'Bank Account Number is mandatory';
        StartDateErr: Label 'Start Date is mandatory';
        EndDateErr: Label 'End Date is mandatory';
}