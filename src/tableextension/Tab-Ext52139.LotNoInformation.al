tableextension 52139 "NTS Lot No. Information" extends "Lot No. Information"
{
    fields
    {
        field(52101; "NTS Lot No. Notes"; Blob)
        {
            Caption = 'Lot No. Notes';
            Subtype = Memo;
        }
        field(52102; "NTS Lot No. Notes Exists"; Boolean)
        {
            Caption = 'Lot No. Notes Exists';
            Editable = false;
        }
    }
    trigger OnBeforeInsert()
    begin
        HasLotNoNotes();
    end;

    trigger OnBeforeModify()
    begin
        HasLotNoNotes();
    end;

    procedure SetLotNoNotes(NewNotes: Text)
    var
        OutStream: OutStream;
    begin

        Clear(Rec."NTS Lot No. Notes");
        rec."NTS Lot No. Notes".CreateOutStream(OutStream, TEXTENCODING::UTF8);
        OutStream.WriteText(NewNotes);

        rec.Modify();
    end;

    procedure GetLotNoNotes(): Text
    var
        TypeHelper: Codeunit "Type Helper";
        InStream: InStream;
    begin
        rec.CalcFields("NTS Lot No. Notes");

        if not rec."NTS Lot No. Notes".HasValue then
            exit('');

        rec."NTS Lot No. Notes".CreateInStream(InStream, TEXTENCODING::UTF8);

        exit(
            TypeHelper.TryReadAsTextWithSepAndFieldErrMsg(
                InStream,
                TypeHelper.LFSeparator(),
                rec.FieldName("NTS Lot No. Notes")
            )
        );
    end;

    procedure HasLotNoNotes()
    begin
        rec.CalcFields("NTS Lot No. Notes");
        if Rec."NTS Lot No. Notes".HasValue then
            Rec."NTS Lot No. Notes Exists" := true
        else
            Rec."NTS Lot No. Notes Exists" := false;
    end;
}
