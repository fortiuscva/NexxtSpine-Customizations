tableextension 52140 "NTS Posted Assembly Header" extends "Posted Assembly Header"
{
    fields
    {
        field(52133; "NTS Work Description"; Blob)
        {
            Caption = 'Work Description';
            DataClassification = CustomerContent;
        }
    }
    procedure GetWorkDescription() WorkDescription: Text
    var
        TypeHelper: Codeunit "Type Helper";
        InStream: InStream;
        HasValue: Boolean;
    begin
        Rec.CalcFields("NTS Work Description");
        HasValue := Rec."NTS Work Description".HasValue;
        Rec."NTS Work Description".CreateInStream(InStream, TEXTENCODING::UTF8);
        exit(TypeHelper.TryReadAsTextWithSepAndFieldErrMsg(InStream, TypeHelper.LFSeparator(), Rec.FieldName("NTS Work Description")));
    end;
}
