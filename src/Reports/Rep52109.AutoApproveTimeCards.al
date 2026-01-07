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
            DataItemTableView = where(Open = const(false));
            RequestFilterFields = "No.";
            trigger OnAfterGetRecord()
            var
                cuTCMApproval: Codeunit "SFI Time Card Approval Mgmt";
                cuTCMPost: Codeunit "SFI Time Card-Post";
                cuLineValidator: Codeunit "SFI Time Card Line Validation";
                cuHooks: Codeunit "SFI AL Hooks";
                rbHadErrors: Boolean;
                lcuWorkflowApprovalIntegration: codeunit "SFI Workflow Approval Handling";
            begin
                if not SFITimeCardHeader.Open then begin
                    cuTCMApproval.approveTimecard(SFITimeCardHeader);
                end;
                if SFITimeCardHeader.Approved then begin
                    cuTCMPost.setHidePrompt(true);
                    SFITimeCardHeader.SetRecFilter();
                    cuTCMPost.RUN(SFITimeCardHeader);
                end;
            end;
        }
    }


}
