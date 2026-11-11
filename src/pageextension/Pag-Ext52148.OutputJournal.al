pageextension 52148 "NTS Output Journal" extends "Output Journal"
{
    layout
    {
        addafter("Operation No.")
        {
            field("NTS Is Last Operation"; Rec."NTS Is Last Operation")
            {
                ApplicationArea = All;
                Caption = 'Is Last Operation';
            }
        }
    }
    actions
    {
        addlast(Processing)
        {
            action("NTS Delete Item Tracking for Selected Lines")
            {
                ApplicationArea = Manufacturing;
                Caption = 'Delete Item Tracking for Selected Lines';
                Image = Delete;
                ToolTip = 'Delete tracking and reservation entries for the selected output journal lines.';

                trigger OnAction()
                var
                    ItemJnlLine: Record "Item Journal Line";
                    ItemJnlLineReserve: Codeunit "Item Jnl. Line-Reserve";
                    SingleInstanceCU: Codeunit "NTS Single Instance";
                    DeletedCount: Integer;
                begin
                    if not Confirm(TrackingLineDeleteConfirmMsg, false) then
                        exit;
                    CurrPage.SetSelectionFilter(ItemJnlLine);

                    if ItemJnlLine.FindSet() then
                        repeat
                            SingleInstanceCU.SetHideDeleteItemTrackingConfirm(true);
                            ItemJnlLineReserve.DeleteLine(ItemJnlLine);
                            DeletedCount += 1;
                            SingleInstanceCU.SetHideDeleteItemTrackingConfirm(false);

                        until ItemJnlLine.Next() = 0;
                    if DeletedCount > 0 then
                        Message(StrSubstNo(TrackingLinesDeleteSuccessMsg, DeletedCount))
                    else
                        Message(NothingToDeleteMsg);
                    CurrPage.Update(false);
                end;
            }
        }
    }
    var
        TrackingLineDeleteConfirmMsg: Label 'Do you want to delete the tracking lines for the selected Journal Lines?';
        TrackingLinesDeleteSuccessMsg: Label '%1 Item tracking Line(s) deleted successfully';
        NothingToDeleteMsg: Label 'There is nothing to delete';

}