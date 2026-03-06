report 52115 "NTS Delete Reservation Entries"
{
    ApplicationArea = All;
    Caption = 'Delete Reservation Entries';
    UsageCategory = ReportsAndAnalysis;
    ProcessingOnly = true;

    dataset
    {
        dataitem(ReservationEntry; "Reservation Entry")
        {
            DataItemTableView = sorting("Entry No.", Positive);
            RequestFilterFields = "Entry No.", "Source ID", "Item No.", "Source Batch Name";

            trigger OnAfterGetRecord()
            begin
                Delete(true);
            end;
        }
    }
}
