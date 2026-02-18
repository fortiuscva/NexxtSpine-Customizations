report 52112 "NTS Transfer Shipment PL"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/Reports/Layout/TransferShipmentPL.rdl';
    Caption = 'Posted Transfer Shipment Packing List';
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
            {
            }
            column(Invoice_Caption; Invoice_CaptionLbl)
            { }
            column(InvoiceNumberValue; '')
            { }
            column(Terms_Caption; Terms_CaptionLbL)
            { }
            // column(Payment_Terms_Code; "Payment Terms Code")
            // { }
            column(PTN_Caption; PTN_CaptionLbl)
            { }
            column(PTNValue; '')
            { }
            column(Tracking_Caption; Tracking_CaptionLbl)
            { }
            // column(Package_Tracking_No_; "Package Tracking No.")
            // { }
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

            // column(SSH_SellToContact; "Transfer Shipment Header"."Sell-to Contact")
            // { }
            // column(SSH_ReqDeliveryDate; "Transfer Shipment Header"."Requested Delivery Date")
            // { }
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
            dataitem("Inventory Comment Line"; "Inventory Comment Line")
            {
                DataItemLink = "No." = FIELD("No.");
                DataItemTableView = SORTING("Document Type", "No.", "Line No.") WHERE("Document Type" = CONST("Posted Transfer Shipment"));
                column(DocLine_InventoryCommentLine; "Inventory Comment Line"."Line No.")
                { }
                column(Date_InventoryCommentLine; "Inventory Comment Line".Date)
                { }
                column(Comment_InventoryCommentLine; "Inventory Comment Line".Comment)
                { }
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
                    column(CompanyInfoPicture; CompanyInfo3.Picture)
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

                    column(TransferFromAddr1; TransferFromAddr[1])
                    {
                    }
                    column(TransferFromAddr2; TransferFromAddr[2])
                    {
                    }
                    column(TransferFromAddr3; TransferFromAddr[3])
                    {
                    }
                    column(TransferFromAddr4; TransferFromAddr[4])
                    {
                    }
                    column(TransferFromAddr5; TransferFromAddr[5])
                    {
                    }
                    column(TransferFromAddr6; TransferFromAddr[6])
                    {
                    }
                    column(TransferFromAddr7; TransferFromAddr[7])
                    {
                    }
                    column(TransferFromAddr8; TransferFromAddr[8])
                    {
                    }
                    column(TransferToAddr1; TransferToAddr[1])
                    {
                    }
                    column(TransferToAddr2; TransferToAddr[2])
                    {
                    }

                    column(TransferToAddr3; TransferToAddr[3])
                    {
                    }

                    column(TransferToAddr4; TransferToAddr[4])
                    {
                    }

                    column(TransferToAddr5; TransferToAddr[5])
                    {
                    }
                    column(TransferToAddr6; TransferToAddr[6])
                    {
                    }
                    column(TransferToAddr7; TransferToAddr[7])
                    {
                    }
                    column(TransferToAddr8; TransferToAddr[8])
                    {
                    }
                    // column(BilltoCustNo_SalesShptHeader; "Transfer Shipment Header"."Bill-to Customer No.")
                    // {
                    // }
                    column(ExtDocNo_TransferShptHeader; "Transfer Shipment Header"."External Document No.")
                    {
                    }
                    column(SalesPurchPersonName; SalesPurchPerson.Name)
                    {
                    }
                    column(ShptDate_TransferShptHeader; "Transfer Shipment Header"."Shipment Date")
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
                    // column(PackageTrackingNoText; PackageTrackingNoText)
                    // {
                    // }
                    // column(ShippingAgentCodeText; ShippingAgentCodeText)
                    // {
                    // }
                    // column(ShippingAgentCodeLabel; ShippingAgentCodeLabel)
                    // {
                    // }
                    // column(PackageTrackingNoLabel; PackageTrackingNoLabel)
                    // {
                    // }
                    // column(TaxRegNo; TaxRegNo)
                    // {
                    // }
                    // column(TaxRegLabel; TaxRegLabel)
                    // {
                    // }
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
                    dataitem(TransferShptLine; "Integer")
                    {
                        DataItemTableView = SORTING(Number);
                        column(TransferShptLineNumber; Number)
                        {
                        }
                        column(TempTransferShptLineNo; TempTransferShipmentLine."Line No.")
                        {
                        }
                        // column(TempTransferShipmentLine_PackageTrackingNo; TempTransferShipmentLine."Package Tracking No.")
                        // { }
                        column(TempTransferShptLineUOM; TempTransferShipmentLine."Unit of Measure Code")
                        {
                        }
                        column(TempTransferShptLineQy; TempTransferShipmentLine.Quantity)
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
                        column(TempTransferShptLineDesc; TempTransferShipmentLine.Description + ' ' + TempTransferShipmentLine."Description 2")
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
                        column(DescriptionCaption; DescriptionCaptionLbl)
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
                        // dataitem(AsmLoop; "Integer")
                        // {
                        //     DataItemTableView = SORTING(Number);
                        //     column(PostedAsmLineItemNo; BlanksForIndent() + PostedAsmLine."No.")
                        //     {
                        //     }
                        //     column(PostedAsmLineDescription; BlanksForIndent() + PostedAsmLine.Description)
                        //     {
                        //     }
                        //     column(PostedAsmLineQuantity; PostedAsmLine.Quantity)
                        //     {
                        //         DecimalPlaces = 0 : 5;
                        //     }
                        //     column(PostedAsmLineUOMCode; GetUnitOfMeasureDescr(PostedAsmLine."Unit of Measure Code"))
                        //     {
                        //     }

                        //     trigger OnAfterGetRecord()
                        //     begin
                        //         if Number = 1 then
                        //             PostedAsmLine.FindSet()
                        //         else
                        //             PostedAsmLine.Next();
                        //     end;

                        //     trigger OnPreDataItem()
                        //     begin
                        //         if not DisplayAssemblyInformation then
                        //             CurrReport.Break();
                        //         if not AsmHeaderExists then
                        //             CurrReport.Break();
                        //         if not TempTransferShipmentLineAsm.Get(TempTransferShipmentLine."Document No.", TempTransferShipmentLine."Line No.") then
                        //             CurrReport.Break();
                        //         PostedAsmLine.SetRange("Document No.", PostedAsmHeader."No.");
                        //         SetRange(Number, 1, PostedAsmLine.Count);
                        //     end;
                        // }
                        // dataitem(ItemTrackingSpec; Integer)
                        // {
                        //     DataItemTableView = sorting(Number);
                        //     DataItemLinkReference = TransferShptLine;
                        //     column(TempItemLedgEntry_ItemNo; TempTrackingSpecBuffer."Item No.")
                        //     { }
                        //     column(TempItemLedgEntry_LotNo; LotNo)
                        //     { }
                        //     column(Tracking_Number; Number)
                        //     { }
                        //     column(TempTrackingSpecBuffer_Qty; TempTrackingSpecBuffer."Quantity (Base)")
                        //     { }
                        //     column(Lot_Serial_Caption; Lot_Serial_CaptionLbl)
                        //     { }
                        //     column(ExpirationDate; TempTrackingSpecBuffer."Expiration Date")
                        //     { }

                        //     trigger OnAfterGetRecord()
                        //     begin
                        //         if Number = 1 then begin
                        //             TempTrackingSpecBuffer.FindSet();
                        //             LotNo := TempTrackingSpecBuffer."Serial No.";
                        //         end else begin
                        //             TempTrackingSpecBuffer.Next();
                        //             LotNo := TempTrackingSpecBuffer."Serial No.";
                        //         end;
                        //     end;

                        //     trigger OnPreDataItem()
                        //     begin
                        //         TempTrackingSpecBuffer.SetRange("Source Ref. No.", TempTransferShipmentLine."Line No.");
                        //         if TempTrackingSpecBuffer.Count = 0 then
                        //             CurrReport.Break();
                        //         SetRange(Number, 1, TempTrackingSpecBuffer.Count);
                        //         Error('B) %1', TempTrackingSpecBuffer.Count);
                        //     end;
                        // }
                        trigger OnAfterGetRecord()
                        var
                            TransferShipmentLine: Record "Transfer Shipment Line";
                        begin
                            OnLineNumber := OnLineNumber + 1;

                            with TempTransferShipmentLine do begin
                                if OnLineNumber = 1 then
                                    Find('-')
                                else
                                    Next();


                                //     OrderedQuantity := 0;
                                //     BackOrderedQuantity := 0;
                                //     if "Transfer Order No." = '' then
                                //         OrderedQuantity := Quantity
                                //     else
                                //         if OrderLine.Get(1, "Order No.", "Order Line No.") then begin
                                //             OrderedQuantity := OrderLine.Quantity;
                                //             BackOrderedQuantity := OrderLine."Outstanding Quantity";
                                //         end else begin
                                //             ReceiptLine.SetCurrentKey("Order No.", "Order Line No.");
                                //             ReceiptLine.SetRange("Order No.", "Order No.");
                                //             ReceiptLine.SetRange("Order Line No.", "Order Line No.");
                                //             ReceiptLine.Find('-');
                                //             repeat
                                //                 OrderedQuantity := OrderedQuantity + ReceiptLine.Quantity;
                                //             until 0 = ReceiptLine.Next();
                                //         end;

                                //     if Type = Type::" " then begin
                                //         OrderedQuantity := 0;
                                //         BackOrderedQuantity := 0;
                                //         "No." := '';
                                //         "Unit of Measure" := '';
                                //         Quantity := 0;
                                //     end else
                                //         if Type = Type::"G/L Account" then
                                //             "No." := '';

                                //     PackageTrackingText := '';
                                //     if ("Package Tracking No." <> "Transfer Shipment Header"."Package Tracking No.") and
                                //        ("Package Tracking No." <> '') and PrintPackageTrackingNos
                                //     then
                                //         PackageTrackingText := Text002 + ' ' + "Package Tracking No.";

                                //     if DisplayAssemblyInformation then
                                //         if TempTransferShipmentLineAsm.Get("Document No.", "Line No.") then begin
                                //             SalesShipmentLine.Get("Document No.", "Line No.");
                                //             AsmHeaderExists := SalesShipmentLine.AsmToShipmentExists(PostedAsmHeader);
                                //         end;

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
                //     if PrintCompany then
                //         if RespCenter.Get("Responsibility Center") then begin
                //             FormatAddress.RespCenter(CompanyAddress, RespCenter);
                //             CompanyInformation."Phone No." := RespCenter."Phone No.";
                //             CompanyInformation."Fax No." := RespCenter."Fax No.";
                //         end;
                //     CurrReport.Language := LanguageGbl.GetLanguageIdOrDefault("Language Code");

                //     if "Salesperson Code" = '' then
                //         Clear(SalesPurchPerson)
                //     else
                //         SalesPurchPerson.Get("Salesperson Code");

                //     if "Shipment Method Code" = '' then
                //         Clear(ShipmentMethod)
                //     else
                //         ShipmentMethod.Get("Shipment Method Code");

                //     if "Sell-to Customer No." = '' then begin
                //         "Bill-to Name" := Text009;
                //         "Ship-to Name" := Text009;
                //     end;
                //     if not Cust.Get("Sell-to Customer No.") then
                //         Clear(Cust);

                //     FormatAddress.SalesShptBillTo(BillToAddress, BillToAddress, "Transfer Shipment Header");
                //     FormatAddress.SalesShptShipTo(ShipToAddress, "Transfer Shipment Header");

                //     ShippingAgentCodeLabel := '';
                //     ShippingAgentCodeText := '';
                //     PackageTrackingNoLabel := '';
                //     PackageTrackingNoText := '';
                //     if PrintPackageTrackingNos then begin
                //         ShippingAgentCodeLabel := Text003;
                //         ShippingAgentCodeText := "Transfer Shipment Header"."Shipping Agent Code";
                //         PackageTrackingNoLabel := Text001;
                //         PackageTrackingNoText := "Transfer Shipment Header"."Package Tracking No.";
                //     end;
                //     if LogInteraction then
                //         if not CurrReport.Preview then
                //             SegManagement.LogDocument(
                //               5, "No.", 0, 0, DATABASE::Customer, "Sell-to Customer No.",
                //               "Salesperson Code", "Campaign No.", "Posting Description", '');
                //     TaxRegNo := '';
                //     TaxRegLabel := '';
                //     if "Tax Area Code" <> '' then begin
                //         TaxArea.Get("Tax Area Code");
                //         case TaxArea."Country/Region" of
                //             TaxArea."Country/Region"::US:
                //                 ;
                //             TaxArea."Country/Region"::CA:
                //                 begin
                //                     TaxRegNo := CompanyInformation."VAT Registration No.";
                //                     TaxRegLabel := CompanyInformation.FieldCaption("VAT Registration No.");
                //                 end;
                //         end;
                //     end;
                // end;

                FormatAddress.TransferShptTransferFrom(TransferFromAddr, "Transfer Shipment Header");
                FormatAddress.TransferShptTransferTo(TransferToAddr, "Transfer Shipment Header");

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
                    field(PrintPackageTrackingNos; PrintPackageTrackingNos)
                    {

                        Visible = false;
                        ApplicationArea = Basic, Suite;
                        Caption = 'Print Package Tracking Nos.';
                        ToolTip = 'Specifies if you want the individual package tracking numbers to be printed on each line.';
                    }
                    field(LogInteraction; LogInteraction)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Log Interaction';
                        Enabled = LogInteractionEnable;
                        ToolTip = 'Specifies if you want to record the related interactions with the involved contact person in the Interaction Log Entry table.';
                    }
                    field(DisplayAsmInfo; DisplayAssemblyInformation)
                    {
                        ApplicationArea = Assembly;
                        Caption = 'Show Assembly Components';
                        ToolTip = 'Specifies that you want the report to include information about components that were used in linked assembly orders that supplied the item(s) being sold.';
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

    trigger OnInitReport()
    begin
        CompanyInfo.Get();
        SalesSetup.Get();

        case SalesSetup."Logo Position on Documents" of
            SalesSetup."Logo Position on Documents"::"No Logo":
                ;
            SalesSetup."Logo Position on Documents"::Left:
                begin
                    CompanyInfo3.Get();
                    CompanyInfo3.CalcFields(Picture);
                end;
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
    end;

    trigger OnPreReport()
    begin
        if not CurrReport.UseRequestPage then
            InitLogInteraction();

        CompanyInformation.Get();
        SalesSetup.Get();

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
        ReceiptLine: Record "Transfer Shipment Line";
        OrderLine: Record "Sales Line";
        SalesPurchPerson: Record "Salesperson/Purchaser";
        CompanyInformation: Record "Company Information";
        CompanyInfo1: Record "Company Information";
        CompanyInfo2: Record "Company Information";
        CompanyInfo3: Record "Company Information";
        CompanyInfo: Record "Company Information";
        SalesSetup: Record "Sales & Receivables Setup";
        TempTransferShipmentLine: Record "Transfer Shipment Line" temporary;
        TempTransferShipmentLineAsm: Record "Transfer Shipment Line" temporary;
        RespCenter: Record "Responsibility Center";
        TaxArea: Record "Tax Area";
        Cust: Record Customer;
        PostedAsmHeader: Record "Posted Assembly Header";
        PostedAsmLine: Record "Posted Assembly Line";
        LanguageGbl: Codeunit Language;
        SalesShipmentPrinted: Codeunit "Sales Shpt.-Printed";
        FormatAddress: Codeunit "Format Address";
        FormatDocument: Codeunit "Format Document";
        SegManagement: Codeunit SegManagement;
        CompanyAddress: array[8] of Text[100];
        TransferFromAddr: array[8] of Text[100];
        TransferToAddr: array[8] of Text[100];
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
        PrintPackageTrackingNos: Boolean;
        PackageTrackingNoText: Text;
        PackageTrackingNoLabel: Text;
        ShippingAgentCodeText: Text;
        ShippingAgentCodeLabel: Text;
        LogInteraction: Boolean;
        Text000: Label 'COPY';
        Text001: Label 'Tracking No.';
        Text002: Label 'Specific Tracking No.';
        Text003: Label 'Shipping Agent';
        TaxRegNo: Text;
        TaxRegLabel: Text;
        OutputNo: Integer;
        Text009: Label 'VOID SHIPMENT';
        [InDataSet]
        LogInteractionEnable: Boolean;
        DisplayAssemblyInformation: Boolean;
        AsmHeaderExists: Boolean;
        BillCaptionLbl: Label 'Customer Address';
        ToCaptionLbl: Label 'To:';
        CustomerIDCaptionLbl: Label 'CUSTOMER #';
        PONumberCaptionLbl: Label 'CUSTOMER P/O #';
        SalesPersonCaptionLbl: Label 'SalesPerson';
        ShipCaptionLbl: Label 'Ship to Address';
        ShipmentCaptionLbl: Label 'PACKING LIST';
        ShipmentNumberCaptionLbl: Label 'SHIPMENT #';
        ShipmentDateCaptionLbl: Label 'ORDER DATE';
        PageCaptionLbl: Label 'Page:';
        ShipViaCaptionLbl: Label 'SHIP VIA';
        PODateCaptionLbl: Label 'P.O. Date';
        OurOrderNoCaptionLbl: Label 'SALES ORDER #';
        ItemNoCaptionLbl: Label 'Item Number';
        UnitCaptionLbl: Label 'UOM';
        DescriptionCaptionLbl: Label 'Item Description';
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
        Lot_Detail_Info_CaptionLbl: Label 'Lot Detail Information:';
        Item_CaptionLbl: Label 'Item';
        Lot_Serial_CaptionLbl: Label 'Lot / Serial Number';
        Qty_CaptionLbl: Label 'Quantity';
        LineCount: Integer;
        ShowLotSN: Boolean;
        ShowTotal: Boolean;
        ShowGroup: Boolean;
        TotalQty: Decimal;
        QuantityCaptionLbl: Label 'Quantity';
        SerialNoCaptionLbl: Label 'Serial No.';
        LotNoCaptionLbl: Label 'Lot No.';
        SerialLotNo: Text;
        NoCaptionLbl: Label 'No.';
        TempTrackingSpecBuffer: Record "Tracking Specification" temporary;
        LotNo: Text;

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
        ItemTrackDocMgmt: Codeunit "Item Tracking Doc. Management";
        ItemLedgerEntryLcl: Record "Item Ledger Entry";
    begin
        Clear(TempTrackingSpecBuffer);
        TempTrackingSpecBuffer.DeleteAll();

        // ItemTrackDocMgmt.RetrieveDocumentItemTracking(TempTrackingSpecBuffer, "Transfer Shipment Line"."Document No.", DATABASE::"Transfer Shipment Line", 0);
        Clear(SerialLotNo);
        ItemLedgerEntryLcl.Reset();
        ItemLedgerEntryLcl.SetRange("Entry Type", ItemLedgerEntryLcl."Entry Type"::Transfer);
        ItemLedgerEntryLcl.SetRange("Document Type", ItemLedgerEntryLcl."Document Type"::"Transfer Shipment");
        ItemLedgerEntryLcl.SetRange("Document No.", TempTransferShipmentLine."Document No.");
        ItemLedgerEntryLcl.SetRange("Item No.", TempTransferShipmentLine."Item No.");
        if ItemLedgerEntryLcl.FindSet() then
            repeat
                if ItemLedgerEntryLcl."Serial No." <> '' then
                    SerialLotNo += ItemLedgerEntryLcl."Serial No."
                else
                    SerialLotNo += ItemLedgerEntryLcl."Lot No.";
            until ItemLedgerEntryLcl.Next() = 0;
    end;
}


