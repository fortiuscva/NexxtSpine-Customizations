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
            action("NTS Update Last Operation and Delete Tracking for Selected Lines")
            {
                ApplicationArea = Manufacturing;
                Caption = 'Update Last Operation & Delete Tracking';
                Image = Delete;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Delete tracking,reservation entries and update Last Operation No.for the selected output journal lines.';

                trigger OnAction()
                var
                    ItemJnlLine: Record "Item Journal Line";
                    ItemJnlLineReserve: Codeunit "Item Jnl. Line-Reserve";
                    SingleInstanceCU: Codeunit "NTS Single Instance";
                    DeletedCount: Integer;
                begin
                    Clear(DeletedCount);
                    if not Confirm(TrackingLineDeleteConfirmMsg, false) then
                        exit;
                    CurrPage.SetSelectionFilter(ItemJnlLine);

                    if ItemJnlLine.FindSet() then
                        repeat
                            SingleInstanceCU.SetHideDeleteItemTrackingConfirm(true);
                            NexxtSpineFunctions.UpdateLastOperationNo(ItemJnlLine);
                            ItemJnlLine.Modify(true);
                            if not ItemJnlLine."NTS Is Last Operation" then begin
                                ItemJnlLineReserve.DeleteLine(ItemJnlLine);
                                SingleInstanceCU.SetHideDeleteItemTrackingConfirm(false);
                                DeletedCount += 1;
                            end;
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
        TrackingLineDeleteConfirmMsg: Label 'Do you want to delete item tracking and reservation entries for the selected lines and update the Last Operation No.?';
        TrackingLinesDeleteSuccessMsg: Label '%1 Item tracking Line(s) deleted successfully and Last Operation No. updated.';
        NothingToDeleteMsg: Label 'There is nothing to delete and the Last Operation No. was updated for the selected line(s).';
        NexxtSpineFunctions: Codeunit "NTS NexxtSpine Functions";
}