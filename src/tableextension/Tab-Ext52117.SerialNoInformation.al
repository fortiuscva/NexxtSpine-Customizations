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
    }

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
}
