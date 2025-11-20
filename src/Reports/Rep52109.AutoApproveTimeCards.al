report 52109 "NTS Auto Approve Time Cards"
{
    ApplicationArea = All;
    Caption = 'Auto Approve Time Cards';
    UsageCategory = ReportsAndAnalysis;
    ProcessingOnly = true;
    dataset
    {
        dataitem(SFITimeCardHeader; "SFI Time Card Header")
        {
            RequestFilterFields = "No.";
            trigger OnAfterGetRecord()
            var
                cuTCMApproval: Codeunit "SFI Time Card Approval Mgmt";
            begin
                if not SFITimeCardHeader.Open then
                    cuTCMApproval.approveTimecard(SFITimeCardHeader);
            end;
        }
    }

}
