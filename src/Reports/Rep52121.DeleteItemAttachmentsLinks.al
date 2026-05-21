report 52121 "Delete Item Attachments Links"
{
    ApplicationArea = All;
    Caption = 'Delete Item Attachment Links';
    UsageCategory = ReportsAndAnalysis;
    ProcessingOnly = true;

    dataset
    {
        dataitem(Item; Item)
        {
            RequestFilterFields = "No.";

            trigger OnAfterGetRecord()
            var
                RecRef: RecordRef;
            begin
                RecRef.GetTable(Item);
                RecordLink.Reset();
                RecordLink.SetRange("Record ID", RecRef.RecordId());
                RecordLink.SetRange(Type, RecordLink.Type::Link);
                if RecordLink.FindSet() then
                    repeat
                        RecordLink.Delete();
                        DeletedCount += 1;
                    until RecordLink.Next() = 0;
            end;
        }
    }

    trigger OnPostReport()
    begin
        Message('%1 attachment link(s) deleted.', DeletedCount);
    end;

    var
        RecordLink: Record "Record Link";
        DeletedCount: Integer;
}