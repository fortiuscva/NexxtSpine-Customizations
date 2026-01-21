pageextension 52132 "NTS Item Tracking Lines" extends "Item Tracking Lines"
{
    layout
    {
        addlast(Content)
        {
            grid(NotesGrid)
            {
                Caption = 'Notes';

                group("NTS SerialNotesGrp")
                {

                    ShowCaption = false;

                    field("NTS SerialNoNotes"; SerialNoNotesTxt)
                    {
                        ApplicationArea = All;
                        Editable = false;
                        Caption = 'Serial No. Notes';
                        MultiLine = true;

                    }
                }

                group("NTS LotNotesGrp")
                {
                    ShowCaption = false;

                    field("NTS LotNoNotes"; LotNoNotesTxt)
                    {
                        ApplicationArea = All;
                        Editable = false;
                        Caption = 'Lot No. Notes';
                        MultiLine = true;
                    }
                }
            }
        }
    }
    var
        SerialNoNotesTxt: Text;
        LotNoNotesTxt: Text;

    trigger OnAfterGetRecord()
    begin
        GetSerialLotNoInfo();
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        GetSerialLotNoInfo();
    end;

    procedure GetSerialLotNoInfo()
    var
        SerialNoInfo: Record "Serial No. Information";
        LotNoInfo: Record "Lot No. Information";
    begin
        Clear(SerialNoNotesTxt);
        Clear(LotNoNotesTxt);

        if (Rec."Serial No." <> '') and
           SerialNoInfo.Get(Rec."Item No.", Rec."Variant Code", Rec."Serial No.") then
            SerialNoNotesTxt := SerialNoInfo.GetSerialNoNotes();

        if (Rec."Lot No." <> '') and
           LotNoInfo.Get(Rec."Item No.", Rec."Variant Code", Rec."Lot No.") then
            LotNoNotesTxt := LotNoInfo.GetLotNoNotes();
    end;
}
