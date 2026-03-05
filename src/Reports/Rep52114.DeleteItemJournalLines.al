report 52114 "NTS Delete Item Journal Lines"
{
    ProcessingOnly = true;
    ApplicationArea = All;
    UsageCategory = Tasks;
    Caption = 'Delete Item Journal Lines';

    dataset
    {
        dataitem(ItemJnlLine; "Item Journal Line")
        {
            RequestFilterFields = "Journal Template Name", "Journal Batch Name";

            trigger OnAfterGetRecord()
            begin
                ItemJnlLine.Delete(true);
            end;
        }
    }
}