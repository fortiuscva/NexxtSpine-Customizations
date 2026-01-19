pageextension 52131 "NTS Lot No. Information Card" extends "Lot No. Information Card"
{
    layout
    {
        addlast(General)
        {
            group("NTS LotNo. Notes")
            {
                Caption = 'Lot No. Notes';
                field("NTS Lot No. Notes"; LotNoNotes)
                {
                    ApplicationArea = Basic, Suite;
                    Importance = Additional;
                    MultiLine = true;
                    ShowCaption = false;

                    trigger OnValidate()
                    begin
                        Rec.SetLotNoNotes(LotNoNotes);
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        LotNoNotes := Rec.GetLotNoNotes();
    end;

    var
        LotNoNotes: Text;
}
