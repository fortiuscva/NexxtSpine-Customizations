report 52120 "NTS Serial BOM Inquiry Report"
{
    Caption = 'Serial BOM Inquiry Report';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = './src/Reports/Layout/NTSSerialBOMInquiry.rdl';

    dataset
    {
        dataitem(SerialBOMBuffer; "NTS Serial BOM Inquiry Buffer")
        {

            DataItemTableView = sorting("Entry No.");

            column(ParentItemNo; "Parent Item No.")
            { }
            column(SerialNoFilter; SerialNoFilter)
            { }
            column(CompanyName; CompanyName)
            { }
            column(SerialBomReportCaption; SerialBomReportCaptionLbl)
            { }
            column(SerialNoCaption; SerialNoCaptionLbl)
            { }
            column(ItemNoCaption; ItemNoCaptionLbl)
            { }
            column(SelectedSerialNo; "Serial No.")
            { }
            column(Document_Type; Format("Document Type"))
            { }
            column(ItemNo; "Item No.")
            { }
            column(Description; Description)
            { }
            column(Serial_No_; "Serial No.")
            { }
            column(Lot_No_; "Lot No.")
            { }
            column(Lot_No_1; "Lot No.")
            { }

            column(Quantity; Quantity)
            { }
            column(UnitOfMeasure; "Unit of Measure")
            { }
            column(PostingDate; "Posting Date")
            { }
            column(DocumentNo; "Document No.")
            { }
            column(Location_Code; "Location Code")
            { }
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    field(ParentItemNoFilter; ParentItemNoFilter)
                    {
                        Caption = 'Parent Item No.';
                        ApplicationArea = All;
                        TableRelation = Item;
                    }

                    field(SerialNoFilter; SerialNoFilter)
                    {
                        Caption = 'Serial No.';
                        ApplicationArea = All;
                    }
                }
            }
        }
    }

    trigger OnPreReport()
    var
        NexxtSpineFunctions: Codeunit "NTS NexxtSpine Functions";
        TempBuffer: Record "NTS Serial BOM Inquiry Buffer" temporary;
    begin
        TempBuffer.DeleteAll();
        SerialBOMBuffer.Reset();
        SerialBOMBuffer.DeleteAll();

        NexxtSpineFunctions.BuildInquiry(ParentItemNoFilter, SerialNoFilter, TempBuffer);

        if TempBuffer.FindSet() then
            repeat
                SerialBOMBuffer := TempBuffer;
                SerialBOMBuffer.Insert();
            until TempBuffer.Next() = 0;
    end;

    procedure SetIntialValues(ParentItemNoFilterPar: Code[20]; SerialNoFilterPar: Code[20])
    begin
        ParentItemNoFilter := ParentItemNoFilterPar;
        SerialNoFilter := SerialNoFilterPar;
    end;

    var
        ParentItemNoFilter: Code[20];
        SerialNoFilter: Code[50];
        SerialBomReportCaptionLbl: Label 'Serial BOM Report';
        ItemNoCaptionLbl: Label 'Item No.';
        SerialNoCaptionLbl: Label 'Serial No.';
}