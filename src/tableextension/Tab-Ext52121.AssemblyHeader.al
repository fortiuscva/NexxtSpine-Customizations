tableextension 52121 "NTS Assembly Header" extends "Assembly Header"
{
    fields
    {
        field(52100; "NTS DOR No."; Code[20])
        {
            Caption = 'NTS DOR No.';
            DataClassification = CustomerContent;
        }
        field(52132; "NTS Item Tracking Lines"; Boolean)
        {
            Caption = 'Item Tracking Lines';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = exist("Reservation Entry" where("Source ID" = field("No."), "Source Ref. No." = const(0), "Source Type" = const(900), "Source Subtype" = field("Document Type"), "Reservation Status" = filter(Surplus)));
        }
        field(52133; "NTS Work Description"; Blob)
        {
            DataClassification = CustomerContent;
            Subtype = Memo;
            Caption = 'Work Description';
        }
        field(52134; "NTS Disassembly Component Only"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Disassembly Components Only';
        }

    }
    procedure SetWorkDescription(NewWorkDescription: Text)
    var
        OutStream: OutStream;
    begin
        Clear("NTS Work Description");
        "NTS Work Description".CreateOutStream(OutStream, TEXTENCODING::UTF8);
        OutStream.WriteText(NewWorkDescription);
        Modify();
    end;


    procedure GetWorkDescription() WorkDescription: Text
    var
        TypeHelper: Codeunit "Type Helper";
        InStream: InStream;
    begin
        CalcFields("NTS Work Description");
        "NTS Work Description".CreateInStream(InStream, TEXTENCODING::UTF8);
        exit(TypeHelper.TryReadAsTextWithSepAndFieldErrMsg(InStream, TypeHelper.LFSeparator(), FieldName("NTS Work Description")));
    end;
}
