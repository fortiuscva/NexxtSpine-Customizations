report 52107 "NTS Auto Item Jnl Post"
{
    Caption = 'Auto Item Jnl Post';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = all;

    dataset
    {
        dataitem(ItemJnlLine; "Item Journal Line")
        {
            RequestFilterFields = "Journal Template Name", "Journal Batch Name";

            trigger OnAfterGetRecord()
            begin
                if (not Codeunit.Run(Codeunit::"Item Jnl.-Post Batch", ItemJnlLine)) then;
            end;
        }
    }


}
