report 52107 "NTS Auto Item Jnl Post"
{

    Caption = 'Auto Item Jnl Post';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    ProcessingOnly = true;


    dataset
    {
        dataitem(ItemJnlLine; "Item Journal Line")
        {
            RequestFilterFields = "Journal Template Name", "Journal Batch Name",
                                  "Entry Type", "Posting Date", "Item No.", "Location Code";

            trigger OnAfterGetRecord()
            begin
                if not ItemJnlPostLine.RunWithCheck(ItemJnlLine) then;
            end;
        }
    }

    var
        ItemJnlPostLine: Codeunit "Item Jnl.-Post Line";

}
