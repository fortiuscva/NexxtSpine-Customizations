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
    actions
    {
        addlast(Processing)
        {
            action("NTS Serial BOM Inquiry")
            {
                Caption = 'Serial BOM Inquiry';
                ApplicationArea = All;
                Image = ViewDetails;

                trigger OnAction()
                begin
                    OpenSerialBOMInquiry();
                end;
            }
        }
        addlast(Category_Process)
        {
            actionref("NTS Serial BOM Inquiry_Promoted"; "NTS Serial BOM Inquiry")
            {
            }
        }
    }
    local procedure OpenSerialBOMInquiry()
    var
        TrackingContext: Codeunit "NTS Single instance";
        AssemblyHeader: Record "Assembly Header";
        AssemblyLine: Record "Assembly Line";
        InquiryPage: Page "NTS Serial No. BOM Inquiry";
        InquiryBuffer: Record "NTS Serial BOM Inquiry Buffer" temporary;
        TrackingSpecification: Record "Tracking Specification" temporary;
        DocumentType: Enum "Assembly Document Type";
        DocumentNo: Code[20];
        LineNo: Integer;
    begin
        if not TrackingContext.GetAssemblyLine(DocumentType, DocumentNo, LineNo) then
            Error('The Assembly Line context could not be determined.');

        if not AssemblyHeader.Get(DocumentType, DocumentNo) then
            Error('Assembly Order %1 could not be found.', DocumentNo);

        if not AssemblyLine.Get(DocumentType, DocumentNo, LineNo) then
            Error('Assembly Order %1, Line %2 could not be found.', DocumentNo, LineNo);

        if not AssemblyHeader."NTS Disassembly Component Only" then
            Error('Serial BOM Inquiry is available only for Disassembly Orders.');

        AssemblyHeader.TestField("Item No.");
        AssemblyHeader.TestField("NTS Serial No.");
        AssemblyLine.TestField("No.");

        InquiryPage.SetComponentFilter(AssemblyLine."No.");
        InquiryPage.SetParameters(AssemblyHeader."Item No.", AssemblyHeader."NTS Serial No.");
        InquiryPage.LookupMode(true);
        if InquiryPage.RunModal() <> Action::LookupOK then
            exit;

        Clear(InquiryBuffer);

        InquiryPage.GetSelection(InquiryBuffer);
        if InquiryBuffer."Item No." = '' then
            exit;

        if InquiryBuffer."Item No." <> AssemblyLine."No." then
            Error('Item %1 cannot be selected for Assembly Line Item %2.', InquiryBuffer."Item No.", AssemblyLine."No.");

        Clear(TrackingSpecification);

        TrackingSpecification := Rec;
        TrackingSpecification."Entry No." := 0;
        TrackingSpecification."Item No." := AssemblyLine."No.";
        TrackingSpecification."Variant Code" := AssemblyLine."Variant Code";
        TrackingSpecification."Location Code" := AssemblyLine."Location Code";
        TrackingSpecification."Qty. per Unit of Measure" := AssemblyLine."Qty. per Unit of Measure";
        if TrackingSpecification."Qty. per Unit of Measure" = 0 then
            TrackingSpecification."Qty. per Unit of Measure" := 1;
        TrackingSpecification.Validate("Lot No.", InquiryBuffer."Lot No.");
        TrackingSpecification."Serial No." := InquiryBuffer."Serial No.";
        TrackingSpecification.Validate("Quantity (Base)", Abs(InquiryBuffer.Quantity) * TrackingSpecification."Qty. per Unit of Measure");
        TrackingSpecification.Validate("Quantity Handled (Base)", 0);
        TrackingSpecification.Validate("Quantity Invoiced (Base)", 0);
        InsertRecord2(TrackingSpecification);
        CurrPage.Update(false);
    end;

    procedure InsertRecord2(var NewTrackingSpecification: Record "Tracking Specification" temporary)
    begin
        Rec := NewTrackingSpecification;
        Rec."Entry No." := NextEntryNo();
        if InsertIsBlocked then
            exit;

        if ZeroLineExists() then
            exit;

        if TestTempSpecificationExists() then
            exit;

        TempItemTrackLineInsert.TransferFields(Rec);
        TempItemTrackLineInsert.Insert();
        Rec.Insert();

        ItemTrackingDataCollection.UpdateTrackingDataSetWithChange(
            TempItemTrackLineInsert,
            CurrentSignFactor * SourceQuantityArray[1] < 0,
            CurrentSignFactor,
            0);

        CalculateSums();
    end;

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
