pageextension 52133 "NTS Lot No. Information List" extends "Lot No. Information List"
{
    layout
    {
        addlast(Control1)
        {
            field("NTS Lot No. Notes"; Rec."NTS Lot No. Notes Exists")
            {
                ApplicationArea = All;
                Caption = 'Lot No. Notes';
                ToolTip = 'Specifies the value of the Lot No. Notes field.', Comment = '%';
            }
        }
    }


    trigger OnOpenPage()
    begin
        Rec.HasLotNoNotes();
    end;

    trigger OnAfterGetRecord()
    begin
        Rec.HasLotNoNotes();
    end;

    var
        LotNoNotes: Text;
        LotNoNotesExists: Boolean;
}
