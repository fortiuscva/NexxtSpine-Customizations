pageextension 52131 "NTS Lot No. Information Card" extends "Lot No. Information Card"
{
    layout
    {
        addlast(General)
        {
            group("NTS LotNo. Notes")
            {
                Caption = 'Lot No. Notes';
                field("NTS Lot No. Notes"; LotNoNotes)
                {
                    ApplicationArea = Basic, Suite;
                    Importance = Additional;
                    MultiLine = true;
                    ShowCaption = false;

                    trigger OnValidate()
                    begin
                        Rec.SetLotNoNotes(LotNoNotes);
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
                    ReadExcelSheet();
                    ImportNotes();
                end;
            }
        }
    }
    trigger OnAfterGetRecord()
    begin
        LotNoNotes := Rec.GetLotNoNotes();
    end;

    procedure ImportNotes()
    var
        SerialNoInfoRecLcl: Record "Serial No. Information";
        LotNoInfoRecLcl: Record "Lot No. Information";
        RowNoVarLcl: Integer;
        ColNoVarLcl: Integer;
        MaxRowNoVarLcl: Integer;
        ItemNoVarLcl: Code[20];
        VariantCodeVarLcl: Code[10];
        SerialNoVarLcl: Code[50];
        LotNoVarLcl: Code[50];
        NotesVarLcl: Text;
    begin

        RowNoVarLcl := 0;
        ColNoVarLcl := 0;
        MaxRowNoVarLcl := 0;

        TempExcelBufferRecGbl.Reset();
        if TempExcelBufferRecGbl.FindLast() then begin
            MaxRowNoVarLcl := TempExcelBufferRecGbl."Row No.";
        end;
        for RowNoVarLcl := 2 to MaxRowNoVarLcl do begin
            ItemNoVarLcl := GetValueAtCell(RowNoVarLcl, 1);
            VariantCodeVarLcl := GetValueAtCell(RowNoVarLcl, 2);
            SerialNoVarLcl := GetValueAtCell(RowNoVarLcl, 3);
            LotNoVarLcl := GetValueAtCell(RowNoVarLcl, 4);
            NotesVarLcl := GetValueAtCell(RowNoVarLcl, 5);
            if LotNoVarLcl <> '' then begin
                if SerialNoVarLcl <> '' then begin
                    SerialNoInfoRecLcl.Get(ItemNoVarLcl, VariantCodeVarLcl, SerialNoVarLcl);
                    SerialNoInfoRecLcl.SetSerialNoNotes(NotesVarLcl);
                    Rec.Get(ItemNoVarLcl, VariantCodeVarLcl, LotNoVarLcl);
                    Rec.SetLotNoNotes(NotesVarLcl);
                end else begin
                    Rec.Get(ItemNoVarLcl, VariantCodeVarLcl, LotNoVarLcl);
                    Rec.SetLotNoNotes(NotesVarLcl);
                end;
            end;
        end;
        Message(ExcelImportSucess);
    end;

    local procedure ReadExcelSheet()
    var
        FileMgtCULcl: Codeunit "File Management";
        IStreamVarLcl: InStream;
        FromFileVarLcl: Text[100];
    begin
        UploadIntoStream(UploadExcelMsg, '', '', FromFileVarLcl, IStreamVarLcl);
        if FromFileVarLcl <> '' then begin
            FileNameVarLcl := FileMgtCULcl.GetFileName(FromFileVarLcl);
            SheetNameVarLcl := TempExcelBufferRecGbl.SelectSheetsNameStream(IStreamVarLcl);
        end else
            Error(NoFileFoundMsg);
        TempExcelBufferRecGbl.Reset();
        TempExcelBufferRecGbl.DeleteAll();
        TempExcelBufferRecGbl.OpenBookStream(IStreamVarLcl, SheetNameVarLcl);
        TempExcelBufferRecGbl.ReadSheet();
    end;

    local procedure GetValueAtCell(RowNoVarLcl: Integer; ColNoVarLcl: Integer): Text
    begin

        TempExcelBufferRecGbl.Reset();
        If TempExcelBufferRecGbl.Get(RowNoVarLcl, ColNoVarLcl) then
            exit(TempExcelBufferRecGbl."Cell Value as Text")
        else
            exit('');
    end;

    var
        LotNoNotes: Text;
        TempExcelBufferRecGbl: Record "Excel Buffer" temporary;
        FileNameVarLcl: Text[100];
        SheetNameVarLcl: Text[100];
        UploadExcelMsg: Label 'Please Choose the Excel file.';
        NoFileFoundMsg: Label 'No Excel file found!';
        ExcelImportSucess: Label 'Excel is successfully imported.';
}
