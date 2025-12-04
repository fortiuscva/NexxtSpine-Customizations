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
                SaveRecord(ItemJnlLine);
            end;
        }
    }

    var
        SavedRecords: List of [RecordID];

    local procedure SaveRecord(Line: Record "Item Journal Line")
    begin
        SavedRecords.Add(Line.RecordId);
    end;

    trigger OnPostReport()
    var
        Line: Record "Item Journal Line";
        RID: RecordID;
        PostBatchCU: Codeunit "Item Jnl.-Post Batch";
    begin
        foreach RID in SavedRecords do begin
            if Line.Get(RID) then begin

                if not Codeunit.Run(Codeunit::"Item Jnl.-Post Batch", Line) then;

            end;
        end;
    end;
}
