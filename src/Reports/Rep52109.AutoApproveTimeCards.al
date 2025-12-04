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
                cuTCMPost: Codeunit "SFI Time Card-Post";
            begin
                if not SFITimeCardHeader.Open then begin
                    cuTCMApproval.approveTimecard(SFITimeCardHeader);
                    cuTCMPost.setHidePrompt(true);
                    cuTCMPost.RUN(SFITimeCardHeader);
                end;
            end;
        }
    }

}
