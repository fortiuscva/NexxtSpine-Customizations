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
        field(52135; "NTS Serial No."; Code[50])
        {
            Caption = 'Serial No.';
            DataClassification = CustomerContent;

            trigger OnLookup()
            var
                TempILE: Record "Item Ledger Entry" temporary;
                SerialLookupPage: Page "NTS Serial No Lookup";
                SerialQuery: Query "NTS Available Serial Nos.";
                EntryNo: Integer;
            begin
                Rec.TestField("Item No.");

                SerialQuery.SetRange(ItemNoFilter, Rec."Item No.");
                SerialQuery.SetFilter(RemQtyFilter, '>0');
                SerialQuery.SetFilter(SerialFilter, '<>%1', '');
                SerialQuery.SetRange(OpenFilter, true);

                SerialQuery.Open();

                while SerialQuery.Read() do begin
                    EntryNo += 1;
                    TempILE.Init();
                    TempILE."Entry No." := EntryNo;
                    TempILE."Item No." := SerialQuery.Item_No_;
                    TempILE."Serial No." := SerialQuery.Serial_No_;
                    TempILE.Open := SerialQuery.Open;
                    TempILE."Remaining Quantity" := SerialQuery.Remaining_Quantity;
                    TempILE.Insert();
                end;
                SerialQuery.Close();

                SerialLookupPage.LoadTempData(TempILE);
                SerialLookupPage.LookupMode(true);
                if SerialLookupPage.RunModal() = Action::LookupOK then begin
                    SerialLookupPage.GetRecord(TempILE);
                    Rec."NTS Serial No." := TempILE."Serial No.";
                end;
            end;
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
