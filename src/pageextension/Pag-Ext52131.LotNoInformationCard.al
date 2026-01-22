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
    actions
    {
        addlast(processing)
        {
            action("NTS ImportNotes")
            {
                ApplicationArea = All;
                Caption = 'Import Notes';
                Image = Import;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                trigger OnAction()
                begin
                    NexxtSpineFunctionsCU.ReadExcelSheet();
                    NexxtSpineFunctionsCU.ImportNotesForSerialNoInfoAndLotNoInfo();
                end;
            }
        }
    }
    trigger OnAfterGetRecord()
    begin
        LotNoNotes := Rec.GetLotNoNotes();
    end;

    var
        LotNoNotes: Text;
        NexxtSpineFunctionsCU: Codeunit "NTS NexxtSpine Functions";
}
