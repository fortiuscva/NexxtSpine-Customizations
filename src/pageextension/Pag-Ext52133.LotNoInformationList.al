pageextension 52133 "NTS Lot No. Information List" extends "Lot No. Information List"
{
    layout
    {
        addlast(Control1)
        {
            field("NTS Lot No. Notes"; LotNoNotesExists)
            {
                ApplicationArea = All;
                Caption = 'Lot No. Notes';
                ToolTip = 'Specifies the value of the Lot No. Notes field.', Comment = '%';
            }
        }
    }
    trigger OnAfterGetRecord()
    begin
        LotNoNotes := Rec.GetLotNoNotes();
        if LotNoNotes <> '' then
            LotNoNotesExists := true;
    end;

    var
        LotNoNotes: Text;
        LotNoNotesExists: Boolean;
}
