pageextension 52132 "NTS Item Tracking Lines" extends "Item Tracking Lines"
{
    layout
    {
        addlast(Control1)
        {
            field("NTS Serial No. Notes"; SerialNoNotesTxt)
            {
                ApplicationArea = All;
                Editable = false;
                Caption = 'Serial No. Notes';
            }

            field("NTS Lot No. Notes"; LotNoNotesTxt)
            {
                ApplicationArea = All;
                Editable = false;
                Caption = 'Lot No. Notes';

            }
        }
    }

    var
        SerialNoNotesTxt: Text;
        LotNoNotesTxt: Text;

    trigger OnAfterGetRecord()
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

    trigger OnNewRecord(BelowxRec: Boolean)
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
