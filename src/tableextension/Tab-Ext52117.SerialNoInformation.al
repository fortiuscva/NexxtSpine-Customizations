tableextension 52117 "NTS Serial No. Information" extends "Serial No. Information"
{
    fields
    {
        field(52100; "NTS Set Type"; Enum "NTS Set Type")
        {
            Caption = 'Set Type';
        }
        field(52101; "NTS Serial No. Notes"; Blob)
        {
            Caption = 'Serial No. Notes';
            Subtype = Memo;
        }
        field(52102; "NTS Serial No. Notes Exists"; Boolean)
        {
            Caption = 'Serial No. Notes Exists';
            Editable = false;
        }
    }
    trigger OnBeforeInsert()
    begin
        HasSerialNoNotes();
    end;

    trigger OnBeforeModify()
    begin
        HasSerialNoNotes();
    end;

    procedure SetSerialNoNotes(NewNotes: Text)
    var
        OutStream: OutStream;
    begin

        Clear(Rec."NTS Serial No. Notes");
        rec."NTS Serial No. Notes".CreateOutStream(OutStream, TEXTENCODING::UTF8);
        OutStream.WriteText(NewNotes);

        rec.Modify();
    end;

    procedure GetSerialNoNotes(): Text
    var
        TypeHelper: Codeunit "Type Helper";
        InStream: InStream;
    begin
        rec.CalcFields("NTS Serial No. Notes");

        if not rec."NTS Serial No. Notes".HasValue then
            exit('');

        rec."NTS Serial No. Notes".CreateInStream(InStream, TEXTENCODING::UTF8);

        exit(
            TypeHelper.TryReadAsTextWithSepAndFieldErrMsg(
                InStream,
                TypeHelper.LFSeparator(),
                rec.FieldName("NTS Serial No. Notes")
            )
        );
    end;

    procedure HasSerialNoNotes()
    begin
        rec.CalcFields("NTS Serial No. Notes");
        if Rec."NTS Serial No. Notes".HasValue then
            Rec."NTS Serial No. Notes Exists" := true
        else
            Rec."NTS Serial No. Notes Exists" := false;
    end;
}
