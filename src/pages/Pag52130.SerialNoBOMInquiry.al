page 52130 "NTS Serial No. BOM Inquiry"
{
    PageType = List;
    SourceTable = "NTS Serial BOM Inquiry Buffer";
    SourceTableTemporary = true;
    ApplicationArea = All;
    UsageCategory = Lists;
    Caption = 'Serial No. BOM Inquiry';

    DeleteAllowed = false;
    ModifyAllowed = false;
    InsertAllowed = false;
    layout
    {
        area(content)
        {
            group(Filters)
            {
                Caption = 'Filters';
                field(FilterItemNo; FilterItemNo)
                {
                    Caption = 'Parent Item No.';
                    ApplicationArea = All;
                    TableRelation = Item;
                    Editable = not LockFilters;

                    trigger OnValidate()
                    begin
                        Clear(FilterSerialNo);

                        Rec.Reset();
                        Rec.DeleteAll();

                        CurrPage.Update(false);
                    end;
                }

                field(FilterSerialNo; FilterSerialNo)
                {
                    Caption = 'Serial No.';
                    ApplicationArea = All;
                    Editable = not LockFilters;

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        TempILE: Record "Item Ledger Entry" temporary;
                        SerialLookupPage: Page "NTS Serial No Lookup";
                        SerialQuery: Query "NTS Available Serial Nos.";
                        EntryNo: Integer;
                    begin
                        if FilterItemNo = '' then
                            Error('Select Item No. first.');

                        SerialQuery.SetRange(ItemNoFilter, FilterItemNo);
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
                            FilterSerialNo := TempILE."Serial No.";
                        end;
                    end;

                    trigger OnValidate()
                    begin
                        if FilterSerialNo <> '' then
                            LoadInquiry();
                    end;
                }
            }

            repeater(Lines)
            {
                Caption = 'Lines';
                Editable = false;
                field(Section; Rec."Document Type")
                {
                    Caption = 'Document Type';
                    Visible = false;
                }
                field("Item No."; Rec."Item No.")
                {
                    Caption = 'Item No.';
                }
                field(Description; Rec.Description)
                {
                    Caption = 'Description';
                }
                field(Quantity; Rec.Quantity)
                {
                    Caption = 'Quantity';
                }
                field("Unit of Measure"; Rec."Unit of Measure")
                {
                    Caption = 'Unit of Measure';
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    Caption = 'Posting Date';
                    Visible = false;
                }
                field("Document No."; Rec."Document No.")
                {
                    Caption = 'Document No.';
                    Visible = false;
                }
                field("Serial No."; Rec."Serial No.")
                {
                    Caption = 'Serial No.';
                }
                field("Lot No."; Rec."Lot No.")
                {
                    Caption = 'Lot No.';
                }
                field("Location Code"; Rec."Location Code")
                {
                    Caption = 'Location Code';
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(LoadData)
            {
                Caption = 'Load Inquiry';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    LoadInquiry();
                end;
            }
            action(ShowDetails)
            {
                ApplicationArea = All;
                Caption = 'Show Details';
                Image = ViewDetails;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    DetailPage: Page "NTS Serial BOM Inquiry Details";
                begin
                    DetailPage.SetParameters(FilterItemNo, FilterSerialNo);
                    DetailPage.RunModal();
                end;
            }
            action(PrintReport)
            {
                Caption = 'Print Report';
                ApplicationArea = All;
                Image = Print;

                trigger OnAction()
                var
                    TempBuffer: Record "NTS Serial BOM Inquiry Buffer" temporary;
                    SerialBOMINquireyReport: Report "NTS Serial BOM Inquiry Report";
                begin
                    TempBuffer.Copy(Rec, true);
                    SerialBOMINquireyReport.SetTableView(TempBuffer);
                    SerialBOMINquireyReport.SetIntialValues(FilterItemNo, FilterSerialNo);
                    SerialBOMINquireyReport.RunModal();
                end;
            }

        }
    }

    var
        FilterItemNo: Code[20];
        FilterSerialNo: Code[50];
        NexxtSpineFunctions: Codeunit "NTS NexxtSpine Functions";
        LockFilters: Boolean;

    local procedure LoadInquiry()
    begin
        Rec.Reset();
        Rec.DeleteAll();

        NexxtSpineFunctions.BuildInquiry(FilterItemNo, FilterSerialNo, Rec);

        CurrPage.Update(false);
    end;

    procedure SetParameters(ItemNo: Code[20]; SerialNo: Code[50])
    begin
        FilterItemNo := ItemNo;
        FilterSerialNo := SerialNo;
        LockFilters := true;
        LoadInquiry();
    end;

    procedure GetSelection(var TempBuffer: Record "NTS Serial BOM Inquiry Buffer")
    begin
        CurrPage.SetSelectionFilter(Rec);

        TempBuffer := Rec;
    end;
}