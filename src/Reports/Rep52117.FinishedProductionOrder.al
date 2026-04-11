report 52117 "NTS Finished Production Order"
{
    Caption = 'Finished Production Order';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = './src/Reports/Layout/FinishedProductionOrder.rdl';
    dataset
    {
        dataitem("Production Order"; "Production Order")
        {
            DataItemTableView = SORTING(Status, "No.") ORDER(Ascending) where(Status = const(Finished));
            RequestFilterFields = Status, "No.";
            dataitem("Prod. Order Line"; "Prod. Order Line")
            {
                DataItemLink = Status = FIELD(Status), "Prod. Order No." = FIELD("No.");
                DataItemLinkReference = "Production Order";
                RequestFilterFields = "Line No.";
                column(NTSDrawingNo; GetDrawingNo("Item No."))
                {
                }
                column(NTSRevisionLevel; GetRevisionLevel("Item No."))
                {
                }

                column(NTSLotOrSerial; GetLotOrSerial("Prod. Order No.", "Line No."))
                {
                }
                column(fldProdOrderNo; "Production Order"."No.")
                {
                }
                column(xSection1; 1)
                {
                }
                column(fldSectionator; iSection)
                {
                }
                column(Prod_Order_Source_No; "Production Order"."Source No.")
                {
                }
                column(Prod_Order_Shelf_No; recItem."Shelf No.")
                {
                }
                column(Prod_Order_Quantity; Quantity)
                {
                }
                column(Prod_Order_Est_Weight; recItem."Net Weight")
                {
                }
                column(Prod_Order_Start_Date; FORMAT("Starting Date"))
                {
                }
                column(Prod_Order_End_Date; FORMAT("Ending Date"))
                {
                }
                column(Prod_Order_Description; Description)
                {
                }
                column(Prod_Order_Description2; "Description 2")
                {
                }
                column(Production_Order_Status; Status)
                {
                }
                column(Prod_Order_Line_Line_No; "Line No.")
                {
                }
                column(Prod_Order_Line_Item_No; "Prod. Order Line"."Item No.")
                {
                }
                dataitem("Prod. Order Comment Line"; "Prod. Order Comment Line")
                {
                    DataItemLink = Status = FIELD(Status), "Prod. Order No." = FIELD("Prod. Order No.");
                    DataItemTableView = SORTING(Status, "Prod. Order No.", "Line No.") ORDER(Ascending);
                    column(fldCOmment; Comment)
                    {
                    }
                    column(xSection2; 2)
                    {
                    }
                    column(Prod__Order_Comment_Line_Status; Status)
                    {
                    }
                    column(Prod__Order_Comment_Line_Prod__Order_No_; "Prod. Order No.")
                    {
                    }
                    column(Prod__Order_Comment_Line_Line_No_; "Line No.")
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        iSection := 2;
                    end;

                    trigger OnPreDataItem()
                    begin
                        iSection := 2;
                    end;
                }
                dataitem("Prod. Order Rtng Comment Line"; "Prod. Order Rtng Comment Line")
                {
                    DataItemLink = Status = FIELD(Status), "Prod. Order No." = FIELD("Prod. Order No."), "Routing Reference No." = FIELD("Routing Reference No."), "Routing No." = FIELD("Routing No.");
                    DataItemTableView = SORTING(Status, "Prod. Order No.", "Routing Reference No.", "Routing No.", "Operation No.", "Line No.") ORDER(Ascending);
                    column(fldRtngComment; Comment)
                    {
                    }
                    column(Prod__Order_Rtng_Comment_Line_Status; Status)
                    {
                    }
                    column(Prod__Order_Rtng_Comment_Line_Prod__Order_No_; "Prod. Order No.")
                    {
                    }
                    column(Prod__Order_Rtng_Comment_Line_Line_No_; "Line No.")
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        iSection := 2;
                    end;

                    trigger OnPreDataItem()
                    begin
                        iSection := 2;
                    end;
                }
                dataitem("Prod. Order Component"; "Prod. Order Component")
                {
                    DataItemLink = Status = FIELD(Status), "Prod. Order No." = FIELD("Prod. Order No."), "Prod. Order Line No." = FIELD("Line No.");
                    DataItemTableView = SORTING(Status, "Prod. Order No.", "Prod. Order Line No.", "Line No.") ORDER(Ascending);
                    column(Prod_Comp_Item_Number; "Item No.")
                    {
                    }
                    column(xSection3; 3)
                    {
                    }
                    column(Prod_Comp_Description; Description)
                    {
                    }
                    column(Prod_Comp_Quantity; Quantity)
                    {
                    }
                    column(Prod_Comp_Shelf; getShelfNo("Item No."))
                    {
                    }
                    column(Prod__Order_Component_Status; Status)
                    {
                    }
                    column(Prod__Order_Component_Prod__Order_No_; "Prod. Order No.")
                    {
                    }
                    column(Prod__Order_Component_Prod__Order_Line_No_; "Prod. Order Line No.")
                    {
                    }
                    column(Prod__Order_Component_Line_No_; "Line No.")
                    {
                    }
                    column(QtyConsumed; QtyConsumed)
                    { }
                    column(ItemTrackingCode; ItemTrackingCode)
                    { }

                    trigger OnAfterGetRecord()
                    var
                        ItemLedgerEntry: Record "Item Ledger Entry";
                        ItemRec: Record Item;
                    begin
                        iSection := 3;
                        Clear(QtyConsumed);
                        ItemLedgerEntry.Reset();
                        ItemLedgerEntry.SetRange("Entry Type", ItemLedgerEntry."Entry Type"::Consumption);
                        ItemLedgerEntry.SetRange("Order Type", ItemLedgerEntry."Order Type"::Production);
                        ItemLedgerEntry.SetRange("Order No.", "Prod. Order Component"."Prod. Order No.");
                        ItemLedgerEntry.SetRange("Order Line No.", "Prod. Order Component"."Prod. Order Line No.");
                        ItemLedgerEntry.SetRange("Prod. Order Comp. Line No.", "Prod. Order Component"."Line No.");
                        if ItemLedgerEntry.FindFirst() then begin
                            if (ItemLedgerEntry."Serial No." <> '') then
                                if ItemLedgerEntry."Lot No." <> '' then begin
                                    ItemTrackingCode := ItemLedgerEntry."Serial No." + ',' + ItemLedgerEntry."Lot No.";
                                    QtyConsumed := ItemLedgerEntry.Quantity;
                                end
                                else begin
                                    ItemTrackingCode := ItemLedgerEntry."Serial No.";
                                    QtyConsumed := ItemLedgerEntry.Quantity;
                                end
                            else begin
                                ItemTrackingCode := ItemLedgerEntry."Lot No.";
                                QtyConsumed := ItemLedgerEntry.Quantity;
                            end;
                        end
                        else
                            ItemTrackingCode := '';
                    end;

                    trigger OnPreDataItem()
                    begin
                        iSection := 3;
                    end;
                }
                dataitem("Prod. Order Routing Line"; "Prod. Order Routing Line")
                {
                    DataItemLink = "Prod. Order No." = FIELD("Prod. Order No."), Status = FIELD(Status), "Routing No." = FIELD("Routing No."), "Routing Reference No." = FIELD("Routing Reference No.");
                    DataItemTableView = SORTING(Status, "Prod. Order No.", "Routing Reference No.", "Routing No.", "Operation No.") ORDER(Ascending);
                    RequestFilterFields = "Operation No.", "Work Center No.", "Routing Reference No.", Type, "No.", "Routing Status", "Routing No.";
                    column(xSection4; 4)
                    {
                    }
                    column(Prod__Order_Routing_Line__Operation_No__; "Operation No.")
                    {
                    }
                    column(Prod_Routing_Work_Center; "No.")
                    {
                    }
                    column(Prod_Routing_Description; Description)
                    {
                    }
                    column(Prod_Routing_Est_Time; "Setup Time" + ("Run Time" * "Production Order".Quantity) + ("Wait Time" * "Production Order".Quantity))
                    {
                    }
                    column(Prod__Order_Routing_Line_Status; Status)
                    {
                    }
                    column(Prod__Order_Routing_Line_Prod__Order_No_; "Prod. Order No.")
                    {
                    }
                    column(Prod__Order_Routing_Line_Routing_Reference_No_; "Routing Reference No.")
                    {
                    }
                    column(Prod__Order_Routing_Line_Routing_No_; "Routing No.")
                    {
                    }
                    column(SFI_Total_Posted_Setup_Time; "Prod. Order Routing Line"."SFI Total Posted Setup Time")
                    { }
                    column(SFI_Total_Posted_Run_Time; "Prod. Order Routing Line"."SFI Total Posted Run Time")
                    { }
                    column(Posted_Output_Quantity; "Prod. Order Routing Line"."Posted Output Quantity")
                    { }
                    column(Posted_Scrap_Quantity; "Prod. Order Routing Line"."Posted Scrap Quantity")
                    { }
                    dataitem("Integer"; "Integer")
                    {
                        DataItemTableView = SORTING(Number) ORDER(Ascending);
                        column(codToolNo; codToolNo)
                        {
                        }
                        column(sToolDescription; sToolDescription)
                        {
                        }
                        column(codPersonNo; codPersonNo)
                        {
                        }
                        column(sPersonDescription; sPersonDescription)
                        {
                        }
                        column(codQualityMeasure; codQualityMeasure)
                        {
                        }
                        column(sQualityDescription; sQualityDescription)
                        {
                        }
                        column(sQualityText; sQualityText)
                        {
                        }
                        column(Oper2BlackBag; "Prod. Order Routing Line"."Operation No.")
                        {
                        }
                        column(iIndex; iIndex)
                        {
                        }
                        column(Integer_Number; Number)
                        {
                        }

                        trigger OnAfterGetRecord()
                        begin
                            CLEAR(codToolNo);
                            CLEAR(sToolDescription);
                            CLEAR(codPersonNo);
                            CLEAR(sPersonDescription);
                            CLEAR(codQualityMeasure);
                            CLEAR(sQualityDescription);
                            CLEAR(sQualityText);


                            if (iIndex <> 0) then begin
                                if (iIndex < recTools.COUNT()) then
                                    recTools.Next();
                                if (iIndex < recPersonnel.COUNT()) then
                                    recPersonnel.Next();
                                if (iIndex < recQualityMeasures.COUNT()) then
                                    recQualityMeasures.Next();

                            end;

                            if (iIndex < recTools.COUNT()) then begin
                                sToolDescription := recTools.Description;
                                codToolNo := recTools."No.";
                            end;

                            if (iIndex < recPersonnel.COUNT()) then begin
                                sPersonDescription := recPersonnel.Description;
                                codPersonNo := recPersonnel."No.";
                            end;

                            if (iIndex < recQualityMeasures.COUNT()) then begin
                                codQualityMeasure := recQualityMeasures."Qlty Measure Code";
                                sQualityDescription := recQualityMeasures.Description;
                                sQualityText := StrSubstNo(tcQualityTextTok,
                                    recQualityMeasures."Min. Value",
                                    recQualityMeasures."Max. Value",
                                    recQualityMeasures."Mean Tolerance");
                            end;

                            iIndex := iIndex + 1;
                        end;

                        trigger OnPreDataItem()
                        var
                            liMax: Integer;
                        begin
                            iIndex := 0;

                            liMax := recTools.COUNT();

                            if (recPersonnel.COUNT() > liMax) then
                                liMax := recPersonnel.COUNT();

                            if (recQualityMeasures.COUNT() > liMax) then
                                liMax := recQualityMeasures.COUNT();

                            SetRange(Number, 1, liMax);
                        end;
                    }

                    trigger OnAfterGetRecord()
                    var
                    begin
                        iSection := 4;
                        "Prod. Order Routing Line".CalcFields("SFI Total Posted Setup Time", "SFI Total Posted Run Time", "Posted Output Quantity", "Posted Scrap Quantity");
                        // TotalPostedSetupTime := "Prod. Order Routing Line"."SFI Total Posted Setup Time";
                        recTools.Reset();
                        recPersonnel.Reset();
                        recQualityMeasures.Reset();

                        recTools.SetRange(Status, Status);
                        recTools.SetRange("Prod. Order No.", "Prod. Order No.");
                        recTools.SetRange("Routing Reference No.", "Routing Reference No.");
                        recTools.SetRange("Routing No.", "Routing No.");
                        recTools.SetRange("Operation No.", "Operation No.");
                        if recTools.FIND('-') then;

                        recPersonnel.SetRange(Status, Status);
                        recPersonnel.SetRange("Prod. Order No.", "Prod. Order No.");
                        recPersonnel.SetRange("Routing Reference No.", "Routing Reference No.");
                        recPersonnel.SetRange("Routing No.", "Routing No.");
                        recPersonnel.SetRange("Operation No.", "Operation No.");
                        if recPersonnel.FIND('-') then;

                        recQualityMeasures.SetRange(Status, Status);
                        recQualityMeasures.SetRange("Prod. Order No.", "Prod. Order No.");
                        recQualityMeasures.SetRange("Routing Reference No.", "Routing Reference No.");
                        recQualityMeasures.SetRange("Routing No.", "Routing No.");
                        recQualityMeasures.SetRange("Operation No.", "Operation No.");
                        if recQualityMeasures.FIND('-') then;
                    end;

                    trigger OnPreDataItem()
                    begin
                        iSection := 4;
                    end;
                }
            }

            trigger OnAfterGetRecord()
            begin
                iSection := 1;


                recItem.Reset();
                recItem.SetRange("No.", "Source No.");
                if not recItem.FIND('-') then
                    recItem.INIT(); //<IW author="MH" date="6/10/2014" issue="TFS1368" />
            end;

            trigger OnPreDataItem()
            begin
                iSection := 1;
            end;
        }
    }


    trigger OnInitReport()
    begin

    end;

    var
        recItem: Record Item;
        recTools: Record "Prod. Order Routing Tool";
        recPersonnel: Record "Prod. Order Routing Personnel";
        recQualityMeasures: Record "Prod. Order Rtng Qlty Meas.";
        iSection: Integer;
        codToolNo: Code[20];
        sToolDescription: Text;
        codPersonNo: Code[20];
        sPersonDescription: Text;
        codQualityMeasure: Code[50];
        sQualityDescription: Text;
        sQualityText: Text;
        iIndex: Integer;
        tcQualityTextTok: Label '%1 / %2 / %3', Comment = '%1=min,%2=max, %3=tolerance.';
        QtyConsumed: Decimal;
        ItemTrackingCode: Text;
        TotalPostedSetupTime: Decimal;

    local procedure getShelfNo(pcodItemNo: Code[20]): Code[40]
    var
        lrecItem: Record Item;
    begin

        if lrecItem.GET(pcodItemNo) then
            exit(lrecItem."Shelf No.");

        exit('');
    end;

    local procedure GetDrawingNo(ItemNo: Code[20]): Code[20]
    var
        ItemRec: Record Item;
    begin
        if ItemRec.Get(ItemNo) then
            exit(ItemRec."IMP Drawing Number");
        exit('');
    end;

    local procedure GetRevisionLevel(ItemNo: Code[20]): Code[20]
    var
        ItemRec: Record Item;
    begin
        if ItemRec.Get(ItemNo) then
            exit(ItemRec."IMP Rev Level");
        exit('');
    end;

    local procedure GetLotOrSerial(ProdOrderNo: Code[20]; LineNo: Integer): Code[50]
    var
        ItemLedgerEntry: Record "Item Ledger Entry";
        LotorSerialNo: Text;
    begin
        ItemLedgerEntry.Reset();
        ItemLedgerEntry.SetRange("Entry Type", ItemLedgerEntry."Entry Type"::Output);
        ItemLedgerEntry.SetRange("Order Type", ItemLedgerEntry."Order Type"::Production);
        ItemLedgerEntry.SetRange("Order No.", ProdOrderNo);
        ItemLedgerEntry.SetRange("Order Line No.", LineNo);
        if ItemLedgerEntry.FindFirst() then begin
            if (ItemLedgerEntry."Serial No." <> '') then
                if ItemLedgerEntry."Lot No." <> '' then
                    LotorSerialNo := ItemLedgerEntry."Serial No." + ',' + ItemLedgerEntry."Lot No."
                else
                    LotorSerialNo := ItemLedgerEntry."Serial No."
            else
                LotorSerialNo := ItemLedgerEntry."Lot No.";
        end;
        exit(LotorSerialNo);
    end;
}
