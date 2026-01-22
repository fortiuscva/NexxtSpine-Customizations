pageextension 52112 "Serial No. Information Card" extends "Serial No. Information Card"
{
    layout
    {
        addlast(General)
        {
            field("NTS Set Type"; Rec."NTS Set Type")
            {
                ApplicationArea = All;
            }
            group("NTS SerialNo. Notes")
            {
                Caption = 'Serial No. Notes';
                field("NTS Serial No. Notes"; SerialNoNotes)
                {
                    ApplicationArea = Basic, Suite;
                    Importance = Additional;
                    MultiLine = true;
                    ShowCaption = false;

                    trigger OnValidate()
                    begin
                        Rec.SetSerialNoNotes(SerialNoNotes);
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
        SerialNoNotes := Rec.GetSerialNoNotes();
    end;

    var
        SerialNoNotes: Text;
        NexxtSpineFunctionsCU: Codeunit "NTS NexxtSpine Functions";

}
