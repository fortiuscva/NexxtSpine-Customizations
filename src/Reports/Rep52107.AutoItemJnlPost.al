report 52107 "NTS Auto Item Jnl Post"
{

    Caption = 'Auto Item Jnl Post';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    ProcessingOnly = true;


    dataset
    {
        dataitem("Item Journal Line"; "Item Journal Line")
        {
            RequestFilterFields = "Journal Template Name", "Journal Batch Name",
                                  "Entry Type", "Posting Date", "Item No.", "Location Code";

            trigger OnAfterGetRecord()
            begin
                ItemJnlLine.Reset();
                ItemJnlLine.SetRange("Journal Template Name", "Journal Template Name");
                ItemJnlLine.SetRange("Journal Batch Name", "Journal Batch Name");
                itemjnlLine.SetRange("Line No.", "Line No.");
                if itemjnlLine.FindFirst() then begin
                    SingInstance.SetFromAutoPostItemJnl(true);
                    if not ItemJnlPost.Run(itemjnlLine) then;
                    SingInstance.SetFromAutoPostItemJnl(false);
                end;
            end;
        }

    }


    var

        ItemJnlPostLine: Codeunit "Item Jnl.-Post Line";
        ItemJnlPost: Codeunit "Item Jnl.-Post";
        ItemJnlLine: Record "Item Journal Line";
        ItemTrackingMgt: Codeunit "Item Tracing Mgt.";
        SingInstance: Codeunit "NTS Single Instance";



}
