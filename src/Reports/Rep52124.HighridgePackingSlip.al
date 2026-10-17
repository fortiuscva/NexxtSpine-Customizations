
report 52124 "NTS Highridge Packing Slip"
{
    Caption = 'Highridge Packing Slip';
    ApplicationArea = All;
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = './src/Reports/Layout/HighridgePackingSlip.rdl';

    dataset
    {
        dataitem(TransferShipmentHeader; "Transfer Shipment Header")
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.";
            PrintOnlyIfDetail = true;

            column(ShipmentNo; "No.") { }
            column(TransferOrderNo; "Transfer Order No.") { }
            column(PostingDate; "Posting Date") { }
            column(ShipmentDate; "Shipment Date") { }
            column(ExternalDocumentNo; "External Document No.") { }

            column(TransferToName; "Transfer-to Name") { }

            column(TransferToAddress1; TransferToAddress[1]) { }
            column(TransferToAddress2; TransferToAddress[2]) { }
            column(TransferToAddress3; TransferToAddress[3]) { }
            column(TransferToAddress4; TransferToAddress[4]) { }
            column(TransferToAddress5; TransferToAddress[5]) { }
            column(TransferToAddress6; TransferToAddress[6]) { }
            column(TransferToAddress7; TransferToAddress[7]) { }
            column(TransferToAddress8; TransferToAddress[8]) { }

            column(TransferFromName; "Transfer-from Name") { }

            column(TransferFromAddress1; TransferFromAddress[1]) { }
            column(TransferFromAddress2; TransferFromAddress[2]) { }
            column(TransferFromAddress3; TransferFromAddress[3]) { }
            column(TransferFromAddress4; TransferFromAddress[4]) { }
            column(TransferFromAddress5; TransferFromAddress[5]) { }
            column(TransferFromAddress6; TransferFromAddress[6]) { }
            column(TransferFromAddress7; TransferFromAddress[7]) { }
            column(TransferFromAddress8; TransferFromAddress[8]) { }

            // Replace with the actual custom field if Pack List No.
            // is stored separately from the posted shipment number.
            column(PackListNo; "No.") { }

            // Replace the blank value with the actual NTS description field.
            column(NTSDescriptionValue; WorkDescriptionTxt) { }

            column(CompanyLogo; CompanyInformation.Picture) { }
            column(CompanyName; CompanyInformation.Name) { }
            column(CompanyAddress1; CompanyAddress[1]) { }
            column(CompanyAddress2; CompanyAddress[2]) { }
            column(CompanyAddress3; CompanyAddress[3]) { }
            column(CompanyAddress4; CompanyAddress[4]) { }
            column(CompanyAddress5; CompanyAddress[5]) { }
            column(CompanyAddress6; CompanyAddress[6]) { }
            column(CompanyAddress7; CompanyAddress[7]) { }
            column(CompanyAddress8; CompanyAddress[8]) { }
            column(CompanyPhone; CompanyInformation."Phone No.") { }
            column(CompanyFax; CompanyInformation."Fax No.") { }

            dataitem(TransferShipmentLine; "Transfer Shipment Line")
            {
                DataItemLink = "Document No." = field("No.");
                DataItemTableView = sorting("Document No.", "Line No.");

                column(LineNo; LineCount) { }
                column(ItemNo; "Item No.") { }
                column(ItemDescription; Description) { }
                column(ItemDescription2; "Description 2") { }

                column(QuantityShipped; Quantity)
                {
                    DecimalPlaces = 0 : 5;
                }

                column(UnitOfMeasure; "Unit of Measure Code") { }

                dataitem(ItemTrackingSpec; Integer)
                {
                    DataItemTableView = sorting(Number);

                    column(TrackingNumber; Number) { }
                    column(LotSerialValue; LotSerialValue) { }
                    column(TrackingQuantity; TrackingQuantity)
                    {
                        DecimalPlaces = 0 : 5;
                    }
                    column(TrackingExpirationDate; TrackingExpirationDate) { }

                    trigger OnPreDataItem()
                    begin
                        GetTrackingInformation(TransferShipmentLine);

                        if TempItemLedgEntry.IsEmpty() then begin
                            HasTrackingEntries := false;
                            SetRange(Number, 1, 1);
                        end else begin
                            HasTrackingEntries := true;
                            SetRange(Number, 1, TempItemLedgEntry.Count());
                        end;
                    end;

                    trigger OnAfterGetRecord()
                    begin
                        Clear(LotSerialValue);
                        Clear(TrackingQuantity);
                        Clear(TrackingExpirationDate);

                        if not HasTrackingEntries then
                            exit;

                        if Number = 1 then begin
                            if not TempItemLedgEntry.FindFirst() then
                                CurrReport.Skip();
                        end else
                            if TempItemLedgEntry.Next() = 0 then
                                CurrReport.Skip();

                        if TempItemLedgEntry."Serial No." <> '' then
                            LotSerialValue := TempItemLedgEntry."Serial No."
                        else
                            LotSerialValue := TempItemLedgEntry."Lot No.";

                        TrackingQuantity := Abs(TempItemLedgEntry.Quantity);
                        TrackingExpirationDate := TempItemLedgEntry."Expiration Date";
                    end;
                }

                trigger OnAfterGetRecord()
                begin
                    GetTrackingInformation(TransferShipmentLine);
                    if "Item No." <> '' then
                        LineCount += 1;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                Clear(TransferToAddress);
                Clear(TransferFromAddress);
                FormatAddress.TransferShptTransferTo(TransferToAddress, TransferShipmentHeader);
                FormatAddress.TransferShptTransferFrom(TransferFromAddress, TransferShipmentHeader);
                WorkDescriptionTxt := TransferShipmentHeader.GetWorkDescription();
            end;
        }
    }

    requestpage
    {
        SaveValues = true;
    }

    labels
    {
        ReportTitle = 'CERTIFICATE OF CONFORMANCE';
        CustomerCaption = 'Customer:';
        TransferToAddressCaption = 'Transfer to Address:';
        TransferToCaption = 'Transfer To Name';
        TransferOrderNoCaption = 'Transfer Order No.';
        PostingDateCaption = 'Posting Date';
        PackListCaption = 'Pack List #:';
        DateCaption = 'Date:';
        NTSDescriptionCaption = 'NTS Description Value';
        POCaption = 'PO #:';
        LineItemCaption = 'Line Item';
        PartNumberCaption = 'Part Number';
        DescriptionCaption = 'Description';
        LotSerialRevisionCaption = 'Lot-Serial Number / Rev';
        QuantityShippedCaption = 'Qty Shipped';
        CertificationText = 'Shipment contents have been verified to conform to product specifications. Next Spine certifies that the product listed above was manufactured, processed and inspected in conformance with all applicable drawings, procedures and instructions. We further certify that documentation is available for examination as evidence of conformance to the applicable specifications and will be maintained at our facility indefinitely.';
        ApprovedByCaption = 'Approved by:';
        TitleCaption = 'Title:';
        ApprovalDateCaption = 'Date:';
    }

    trigger OnPreReport()
    begin
        CompanyInformation.Get();
        CompanyInformation.CalcFields(Picture);
        FormatAddress.Company(CompanyAddress, CompanyInformation)
    end;

    var
        CompanyInformation: Record "Company Information";
        TempItemLedgEntry: Record "Item Ledger Entry" temporary;
        ItemTrackingDocMgt: Codeunit "Item Tracking Doc. Management";
        FormatAddress: Codeunit "Format Address";

        TransferToAddress: array[8] of Text[100];
        TransferFromAddress: array[8] of Text[100];
        CompanyAddress: array[8] of Text[100];

        LotSerialValue: Code[50];
        TrackingQuantity: Decimal;
        TrackingExpirationDate: Date;
        HasTrackingEntries: Boolean;
        LineCount: Integer;
        WorkDescriptionTxt: Text;

    local procedure GetTrackingInformation(
        TransferShipmentLineRec: Record "Transfer Shipment Line")
    begin
        TempItemLedgEntry.Reset();
        TempItemLedgEntry.DeleteAll();

        ItemTrackingDocMgt.RetrieveEntriesFromShptRcpt(
            TempItemLedgEntry,
            Database::"Transfer Shipment Line",
            0,
            TransferShipmentLineRec."Document No.",
            '',
            0,
            TransferShipmentLineRec."Line No.");
    end;
}
