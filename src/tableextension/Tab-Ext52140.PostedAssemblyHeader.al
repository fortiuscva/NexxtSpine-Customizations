tableextension 52140 "NTS Posted Assembly Header" extends "Posted Assembly Header"
{
    fields
    {
        field(52100; "NTS DOR No."; Code[20])
        {
            Caption = 'DOR No.';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(52133; "NTS Work Description"; Blob)
        {
            Caption = 'Work Description';
            DataClassification = CustomerContent;
        }
        field(52134; "NTS Disassembly Component Only"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Disassembly Components Only';
            Editable = false;
        }
        field(52135; "NTS Serial No."; Code[50])
        {
            Caption = 'Serial No.';
            DataClassification = CustomerContent;
            Editable = false;
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
