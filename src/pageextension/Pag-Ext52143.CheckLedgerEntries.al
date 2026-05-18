pageextension 52143 "NTS Check Ledger Entries" extends "Check Ledger Entries"
{
    actions
    {
        addlast(Processing)
        {
            action("NTS ExportPositivePay")
            {
                ApplicationArea = All;
                Caption = 'Export Positive Pay';
                Image = Export;

                trigger OnAction()
                begin
                    Report.RunModal(Report::"NTS Export Positive Pay");
                end;
            }
        }
    }
}