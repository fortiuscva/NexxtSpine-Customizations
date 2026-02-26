report 52112 "NTS Transfer Shipment PL"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/Reports/Layout/TransferShipmentPL.rdl';
    Caption = 'Transfer Shipment Packing List';
    ApplicationArea = all;
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("Transfer Shipment Header"; "Transfer Shipment Header")
        {
            DataItemTableView = SORTING("No.");
            PrintOnlyIfDetail = true;
            RequestFilterFields = "No.";
            RequestFilterHeading = 'Posted Transfer Shipment';
            column(No_TransferShptHeader; "No.")
            { }
            column(Lot_Serial_Caption; Lot_Serial_CaptionLbl)
            { }
            column(Invoice_Caption; Invoice_CaptionLbl)
            { }
            column(InvoiceNumberValue; '')
            { }
            column(Terms_Caption; Terms_CaptionLbL)
            { }
            column(Payment_Terms_Code; '')
            { }
            column(PTN_Caption; PTN_CaptionLbl)
            { }
            column(ExtDocNo_SalesShptHeader; "External Document No.")
            { }
            column(OrderDate_SalesShptHeader; "Posting Date")
            { }
            column(OrderNo_SalesShptHeader; "Transfer Order No.")
            {
            }
            column(DescriptionCaption; DescriptionCaptionLbl)
            {
            }
            column(PTNValue; '')
            { }
            column(Tracking_Caption; Tracking_CaptionLbl)
            { }
            column(Package_Tracking_No_; '')
            { }
            column(Sched_Date_Caption; Sched_Date_CaptionLbl)
            { }
            column(Shipment_Date; "Shipment Date")
            { }
            column(Completed_By_Caption; Completed_By_CaptionLbl)
            { }
            column(Checked_By_Caption; Checked_By_CaptionLbl)
            { }
            column(Print_Date_Caption; Print_Date_CaptionLbl)
            { }
            column(Verified_Caption; Verified_CaptionLbl)
            { }
            column(SSH_SellToContact; '')
            { }
            column(SSH_ReqDeliveryDate; "Transfer Shipment Header"."Shipment Date")
            { }
            column(SSH_PostingDate; "Transfer Shipment Header"."Posting Date")
            { }
            column(SSH_LocationCode; "Transfer Shipment Header"."Transfer-to Code")
            { }
            dataitem("Transfer Shipment Line"; "Transfer Shipment Line")
            {
                DataItemLink = "Document No." = FIELD("No.");
                DataItemTableView = SORTING("Document No.", "Line No.");

                trigger OnAfterGetRecord()
                begin
                    TempTransferShipmentLine := "Transfer Shipment Line";
                    TempTransferShipmentLine.Insert();
                    // TempTransferShipmentLineAsm := "Transfer Shipment Line";
                    // TempTransferShipmentLineAsm.Insert();
                    HighestLineNo := "Line No.";
                end;

                trigger OnPreDataItem()
                begin
                    TempTransferShipmentLine.Reset();
                    TempTransferShipmentLine.DeleteAll();
                    // TempTransferShipmentLineAsm.Reset();
                    // TempTransferShipmentLineAsm.DeleteAll();
                end;
            }
            dataitem(CopyLoop; "Integer")
            {
                DataItemTableView = SORTING(Number);
                dataitem(PageLoop; "Integer")
                {
                    DataItemTableView = SORTING(Number) WHERE(Number = CONST(1));
                    column(CompanyInfo2Picture; CompanyInfo2.Picture)
                    {
                    }
                    column(CompanyInfo1Picture; CompanyInfo1.Picture)
                    {
                    }
                    column(CompanyInfoPicture; CompanyInfo.Picture)
                    {
                    }
                    column(CompanyAddress1; CompanyAddress[1])
                    {
                    }
                    column(CompanyAddress2; CompanyAddress[2])
                    {
                    }
                    column(CompanyAddress3; CompanyAddress[3])
                    {
                    }
                    column(CompanyAddress4; CompanyAddress[4])
                    {
                    }
                    column(CompanyAddress5; CompanyAddress[5])
                    {
                    }
                    column(CompanyAddress6; CompanyAddress[6])
                    {
                    }
                    column(CompanyAddress7; CompanyAddress[7])
                    {
                    }
                    column(CompanyAddress8; CompanyAddress[8])
                    {
                    }
                    column(CopyTxt; CopyTxt)
                    {
                    }

                    column(BillToAddress1; BillToAddress[1])
                    {
                    }
                    column(BillToAddress2; BillToAddress[2])
                    {
                    }
                    column(BillToAddress3; BillToAddress[3])
                    {
                    }
                    column(BillToAddress4; BillToAddress[4])
                    {
                    }
                    column(BillToAddress5; BillToAddress[5])
                    {
                    }
                    column(BillToAddress6; BillToAddress[6])
                    {
                    }
                    column(BillToAddress7; BillToAddress[7])
                    {
                    }
                    column(ShipToAddress1; ShipToAddress[1])
                    {
                    }
                    column(ShipToAddress2; ShipToAddress[2])
                    {
                    }
                    column(ShipToAddress3; ShipToAddress[3])
                    {
                    }
                    column(ShipToAddress4; ShipToAddress[4])
                    {
                    }
                    column(ShipToAddress5; ShipToAddress[5])
                    {
                    }
                    column(ShipToAddress6; ShipToAddress[6])
                    {
                    }
                    column(ShipToAddress7; ShipToAddress[7])
                    {
                    }
                    column(BillToAddress8; BillToAddress[8])
                    {
                    }
                    column(ShipToAddress8; ShipToAddress[8])
                    {
                    }
                    column(BilltoCustNo_SalesShptHeader; '')
                    {
                    }
                    column(ExtDocNo_TransferShptHeader; "Transfer Shipment Header"."External Document No.")
                    {
                    }
                    column(SalesPurchPersonName; SalesPurchPerson.Name)
                    {
                    }
                    column(ShptDate_SalesShptHeader; "Transfer Shipment Header"."Shipment Date")
                    {
                    }
                    column(ShipmentMethodDesc; ShipmentMethod.Description)
                    {
                    }
                    column(OrderDate_TransferShptHeader; "Transfer Shipment Header"."Posting Date")
                    {
                    }
                    column(TransferOrderNo_TransferShptHeader; "Transfer Shipment Header"."Transfer Order No.")
                    {
                    }
                    column(PackageTrackingNoText; PackageTrackingNoText)
                    {
                    }
                    column(ShippingAgentCodeText; ShippingAgentCodeText)
                    {
                    }
                    column(ShippingAgentCodeLabel; ShippingAgentCodeLabel)
                    {
                    }
                    column(PackageTrackingNoLabel; PackageTrackingNoLabel)
                    {
                    }
                    column(TaxRegNo; TaxRegNo)
                    {
                    }
                    column(TaxRegLabel; TaxRegLabel)
                    {
                    }
                    column(CopyNo; CopyNo)
                    {
                    }
                    column(PageLoopNumber; Number)
                    {
                    }
                    column(BillCaption; BillCaptionLbl)
                    {
                    }
                    column(ToCaption; ToCaptionLbl)
                    {
                    }
                    column(CustomerIDCaption; CustomerIDCaptionLbl)
                    {
                    }
                    column(PONumberCaption; PONumberCaptionLbl)
                    {
                    }
                    column(SalesPersonCaption; SalesPersonCaptionLbl)
                    {
                    }
                    column(ShipCaption; ShipCaptionLbl)
                    {
                    }
                    column(ShipmentCaption; ShipmentCaptionLbl)
                    {
                    }
                    column(ShipmentNumberCaption; ShipmentNumberCaptionLbl)
                    {
                    }
                    column(ShipmentDateCaption; ShipmentDateCaptionLbl)
                    {
                    }
                    column(PageCaption; PageCaptionLbl)
                    {
                    }
                    column(ShipViaCaption; ShipViaCaptionLbl)
                    {
                    }
                    column(PODateCaption; PODateCaptionLbl)
                    {
                    }
                    column(OurOrderNoCaption; OurOrderNoCaptionLbl)
                    {
                    }
                    dataitem("Inventory Comment Line"; "Inventory Comment Line")
                    {
                        DataItemLinkReference = "Transfer Shipment Header";
                        DataItemLink = "No." = FIELD("No.");
                        DataItemTableView = SORTING("Document Type", "No.", "Line No.") WHERE("Document Type" = CONST("Posted Transfer Shipment"));
                        column(DocLine_SalesCommentLine; "Inventory Comment Line"."Line No.")
                        { }
                        column(Date_InventoryCommentLine; "Inventory Comment Line".Date)
                        { }
                        column(Comment_SalesCommentLine; "Inventory Comment Line".Comment)
                        { }
                    }
                    dataitem(TransferShptLine; "Integer")
                    {
                        DataItemTableView = SORTING(Number);
                        column(SalesShptLineNumber; Number)
                        {
                        }
                        column(TempSalesShptLineNo; TempTransferShipmentLine."Item No.")
                        { }
                        column(TempTransferShptLineNo; TempTransferShipmentLine."Line No.")
                        {
                        }
                        column(TempTransferShipmentLine_PackageTrackingNo; '')
                        { }
                        column(TempTransferShptLineUOM; TempTransferShipmentLine."Unit of Measure Code")
                        {
                        }
                        column(TempSalesShptLineQy; TempTransferShipmentLine.Quantity)
                        {
                            DecimalPlaces = 0 : 5;
                        }
                        column(OrderedQuantity; OrderedQuantity)
                        {
                            DecimalPlaces = 0 : 5;
                        }
                        column(BackOrderedQuantity; BackOrderedQuantity)
                        {
                            DecimalPlaces = 0 : 5;
                        }
                        column(TempSalesShptLineDesc; TempTransferShipmentLine.Description + ' ' + TempTransferShipmentLine."Description 2")
                        {
                        }
                        column(PackageTrackingText; PackageTrackingText)
                        {
                        }
                        column(AsmHeaderExists; AsmHeaderExists)
                        {
                        }
                        column(PrintFooter; PrintFooter)
                        {
                        }
                        column(ItemNoCaption; ItemNoCaptionLbl)
                        {
                        }
                        column(UnitCaption; UnitCaptionLbl)
                        {
                        }

                        column(ShippedCaption; ShippedCaptionLbl)
                        {
                        }
                        column(OrderedCaption; OrderedCaptionLbl)
                        {
                        }
                        column(BackOrderedCaption; BackOrderedCaptionLbl)
                        {
                        }
                        column(LineCount; LineCount)
                        { }
                        column(SerialLotNo; SerialLotNo)
                        { }
                        dataitem(ItemTrackingSpec; Integer)
                        {
                            DataItemTableView = sorting(Number);
                            DataItemLinkReference = TransferShptLine;
                            column(TempItemLedgEntry_ItemNo; TempItemLedgEntry."Item No.")
                            { }
                            column(TempItemLedgEntry_LotNo; LotOrSerialValue)
                            { }
                            column(Tracking_Number; Number)
                            { }
                            column(TempTrackingSpecBuffer_Qty; TempItemLedgEntry.Quantity)
                            { }

                            column(ExpirationDate; TempItemLedgEntry."Expiration Date")
                            { }
                            //temp
                            column(PostedAsmLineItemNo; '')
                            {
                            }
                            column(PostedAsmLineDescription; '')
                            {
                            }
                            column(PostedAsmLineQuantity; '')
                            {

                            }
                            column(PostedAsmLineUOMCode; '')
                            {
                            }
                            trigger OnAfterGetRecord()
                            begin
                                if Number = 1 then
                                    TempItemLedgEntry.FindSet()
                                else
                                    TempItemLedgEntry.Next();

                                if TempItemLedgEntry."Serial No." <> '' then
                                    LotOrSerialValue := TempItemLedgEntry."Serial No."
                                else
                                    LotOrSerialValue := TempItemLedgEntry."Lot No.";


                            end;

                            trigger OnPreDataItem()
                            begin
                                //TempTrackingSpecBuffer.SetRange("Source Ref. No.", TempTransferShipmentLine."Line No.");
                                if TempItemLedgEntry.Count = 0 then
                                    CurrReport.Break();
                                SetRange(Number, 1, TempItemLedgEntry.Count);
                            end;
                        }
                        trigger OnAfterGetRecord()
                        begin
                            OnLineNumber := OnLineNumber + 1;

                            with TempTransferShipmentLine do begin
                                if OnLineNumber = 1 then
                                    Find('-')
                                else
                                    Next();

                                if "Item No." <> '' then
                                    LineCount += 1;
                            end;

                            GetSerialLotNo(TempTransferShipmentLine);
                            if OnLineNumber = NumberOfLines then
                                PrintFooter := true;
                        end;

                        trigger OnPreDataItem()
                        begin
                            NumberOfLines := TempTransferShipmentLine.Count();
                            SetRange(Number, 1, NumberOfLines);
                            OnLineNumber := 0;
                            PrintFooter := false;
                        end;
                    }
                }

                trigger OnAfterGetRecord()
                begin
                    if Number > 1 then begin
                        CopyTxt := Text000;
                        OutputNo += 1;
                    end;
                end;

                trigger OnPreDataItem()
                begin
                    NoLoops := 1 + Abs(NoCopies);
                    SetRange(Number, 1, NoLoops);
                    CopyNo := 0;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                FormatAddress.TransferShptTransferFrom(ShipToAddress, "Transfer Shipment Header");
                FormatAddress.TransferShptTransferTo(BillToAddress, "Transfer Shipment Header");

                if not ShipmentMethod.Get("Shipment Method Code") then
                    ShipmentMethod.Init();
            end;
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
                    Caption = 'Options';
                    field(NoCopies; NoCopies)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Number of Copies';
                        ToolTip = 'Specifies the number of copies of each document (in addition to the original) that you want to print.';
                    }
                    field(PrintCompanyAddress; PrintCompany)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Print Company Address';
                        ToolTip = 'Specifies if your company address is printed at the top of the sheet, because you do not use pre-printed paper. Leave this check box blank to omit your company''s address.';
                    }
                    field(LogInteraction; LogInteraction)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Log Interaction';
                        Enabled = LogInteractionEnable;
                        ToolTip = 'Specifies if you want to record the related interactions with the involved contact person in the Interaction Log Entry table.';
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnInit()
        begin
            LogInteractionEnable := true;
        end;

        trigger OnOpenPage()
        begin
            InitLogInteraction();
            LogInteractionEnable := LogInteraction;
        end;
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        if not CurrReport.UseRequestPage then
            InitLogInteraction();

        CompanyInformation.Get();
        SalesSetup.Get();
        CompanyInformation.CalcFields(Picture);

        case SalesSetup."Logo Position on Documents" of
            SalesSetup."Logo Position on Documents"::"No Logo":
                ;
            SalesSetup."Logo Position on Documents"::Left:
                CompanyInformation.CalcFields(Picture);
            SalesSetup."Logo Position on Documents"::Center:
                begin
                    CompanyInfo1.Get();
                    CompanyInfo1.CalcFields(Picture);
                end;
            SalesSetup."Logo Position on Documents"::Right:
                begin
                    CompanyInfo2.Get();
                    CompanyInfo2.CalcFields(Picture);
                end;
        end;

        if PrintCompany then
            FormatAddress.Company(CompanyAddress, CompanyInformation)
        else
            Clear(CompanyAddress);
    end;

    var
        OrderedQuantity: Decimal;
        BackOrderedQuantity: Decimal;
        ShipmentMethod: Record "Shipment Method";
        SalesPurchPerson: Record "Salesperson/Purchaser";
        CompanyInformation: Record "Company Information";
        CompanyInfo1: Record "Company Information";
        CompanyInfo2: Record "Company Information";
        CompanyInfo: Record "Company Information";
        SalesSetup: Record "Sales & Receivables Setup";
        TempTransferShipmentLine: Record "Transfer Shipment Line" temporary;
        FormatAddress: Codeunit "Format Address";
        FormatDocument: Codeunit "Format Document";
        SegManagement: Codeunit SegManagement;
        CompanyAddress: array[8] of Text[100];
        BillToAddress: array[8] of Text[100];
        ShipToAddress: array[8] of Text[100];
        CopyTxt: Text;
        PrintCompany: Boolean;
        PrintFooter: Boolean;
        NoCopies: Integer;
        NoLoops: Integer;
        CopyNo: Integer;
        NumberOfLines: Integer;
        OnLineNumber: Integer;
        HighestLineNo: Integer;
        PackageTrackingText: Text;
        PackageTrackingNoText: Text;
        PackageTrackingNoLabel: Text;
        ShippingAgentCodeText: Text;
        ShippingAgentCodeLabel: Text;
        LogInteraction: Boolean;
        Text000: Label 'COPY';
        TaxRegNo: Text;
        TaxRegLabel: Text;
        OutputNo: Integer;
        [InDataSet]
        LogInteractionEnable: Boolean;
        AsmHeaderExists: Boolean;
        BillCaptionLbl: Label 'Transfer To';
        ToCaptionLbl: Label 'To:';
        CustomerIDCaptionLbl: Label 'CUSTOMER #';
        PONumberCaptionLbl: Label 'CUSTOMER P/O #';
        SalesPersonCaptionLbl: Label 'SalesPerson';
        ShipCaptionLbl: Label 'Transfer From';
        ShipmentCaptionLbl: Label 'PACKING LIST';
        ShipmentNumberCaptionLbl: Label 'SHIPMENT #';
        ShipmentDateCaptionLbl: Label 'ORDER DATE';
        PageCaptionLbl: Label 'Page:';
        ShipViaCaptionLbl: Label 'SHIP VIA';
        PODateCaptionLbl: Label 'P.O. Date';
        OurOrderNoCaptionLbl: Label 'SALES ORDER #';
        ItemNoCaptionLbl: Label 'Item Number';
        UnitCaptionLbl: Label 'UOM';
        DescriptionCaptionLbl: Label 'Description';
        ShippedCaptionLbl: Label 'Qty Shipped';
        OrderedCaptionLbl: Label 'Ordered';
        BackOrderedCaptionLbl: Label 'Back Ordered';
        Invoice_CaptionLbl: Label 'INVOICE #';
        Terms_CaptionLbL: Label 'TERMS';
        PTN_CaptionLbl: Label 'PTN';
        Tracking_CaptionLbl: Label 'TRACKING #';
        Sched_Date_CaptionLbl: Label 'SCHED. DATE';
        Completed_By_CaptionLbl: Label 'Completed By:';
        Checked_By_CaptionLbl: Label 'Checked By:';
        Print_Date_CaptionLbl: Label 'Print Date:';
        Verified_CaptionLbl: Label 'Verified';
        Lot_Serial_CaptionLbl: Label 'Lot / Serial Number';
        LineCount: Integer;
        SerialLotNo: Text;
        TempItemLedgEntry: Record "Item Ledger Entry" temporary;
        LotOrSerialValue: Code[50];

    procedure InitLogInteraction()
    begin
        LogInteraction := SegManagement.FindInteractionTemplateCode("Interaction Log Entry Document Type"::"Sales Shpt. Note") <> '';
    end;

    procedure GetUnitOfMeasureDescr(UOMCode: Code[10]): Text[10]
    var
        UnitOfMeasure: Record "Unit of Measure";
    begin
        if not UnitOfMeasure.Get(UOMCode) then
            exit(UOMCode);
        exit(UnitOfMeasure.Description);
    end;

    procedure BlanksForIndent(): Text[10]
    begin
        exit(PadStr('', 2, ' '));
    end;

    local procedure InsertTempLine(Comment: Text[80]; IncrNo: Integer)
    begin
        with TempTransferShipmentLine do begin
            Init();
            "Document No." := "Transfer Shipment Header"."No.";
            "Line No." := HighestLineNo + IncrNo;
            HighestLineNo := "Line No.";
        end;
        FormatDocument.ParseComment(Comment, TempTransferShipmentLine.Description, TempTransferShipmentLine."Description 2");
        TempTransferShipmentLine.Insert();
    end;

    local procedure GetSerialLotNo(TempTransferShipmentLine: Record "Transfer Shipment Line" temporary)
    var
        ItemTrackingDocMgt: Codeunit "Item Tracking Doc. Management";
    begin
        Clear(TempItemLedgEntry);
        TempItemLedgEntry.DeleteAll();
        ItemTrackingDocMgt.RetrieveEntriesFromShptRcpt(TempItemLedgEntry, DATABASE::"Transfer Shipment Line", 0, TempTransferShipmentLine."Document No.", '', 0,
                                                        TempTransferShipmentLine."Line No.");
    end;
}