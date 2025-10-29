page 52119 "NTS DOR"
{
    ApplicationArea = All;
    Caption = 'Delivery of Record';
    PageType = Document;
    SourceTable = "NTS DOR Header";
    UsageCategory = None;
    DataCaptionFields = "No.", "Customer Name";
    SourceTableView = where(Posted = filter(false));

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number of the involved entry or record, according to the specified number series.';
                    Visible = DocNoVisible;

                    trigger OnAssistEdit()
                    begin
                        if Rec.AssistEdit(xRec) then
                            CurrPage.Update();
                    end;

                }
                field(Customer; Rec."Customer No.")
                {
                    ToolTip = 'Specifies the value of the Customer field.', Comment = '%';
                }
                field("Customer Name"; Rec."Customer Name")
                {
                    ToolTip = 'Specifies the value of the Customer Name field.', Comment = '%';
                }

                field("Set Name"; Rec."Set Name")
                {
                    ToolTip = 'Specifies the value of the Set Name field.', Comment = '%';
                }
                field("Set Description"; Rec."Set Description")
                {
                    ToolTip = 'Specifies the value of the Set Description field.', Comment = '%';
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ToolTip = 'Specifies the value of the Posting Date field.', Comment = '%';
                }
                field(Status; Rec.Status)
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Status field.', Comment = '%';
                }

                group(ItemTracking)
                {
                    Caption = 'Item Tracking';
                    field("Lot No."; Rec."Lot No.")
                    {
                        ToolTip = 'Specifies the value of the Lot No. field.', Comment = '%';
                    }
                    field("Serial Number"; Rec."Serial No.")
                    {
                        ToolTip = 'Specifies the value of the Serial Number field.', Comment = '%';
                    }
                    field(Quantity; Rec.Quantity)
                    {
                        Editable = false;
                        ToolTip = 'Specifies the value of the Quantity field.', Comment = '%';
                    }
                }

                group(Surgery)
                {
                    Caption = 'Surgery';
                    field(Surgeon; Rec.Surgeon)
                    {
                        ToolTip = 'Specifies the value of the Surgeon field.', Comment = '%';
                    }
                    field("Surgery Date"; Rec."Surgery Date")
                    {
                        ToolTip = 'Specifies the value of the Surgery Date field.', Comment = '%';
                    }
                    field(Distributor; Rec.Distributor)
                    {
                        ToolTip = 'Specifies the value of the Distributor field.', Comment = '%';
                    }
                    field(Reps; Rec."Reps.")
                    {
                        ToolTip = 'Specifies the value of the Reps field.', Comment = '%';
                    }
                    field("Reps. Name"; Rec."Reps. Name")
                    {
                        ToolTip = 'Specifies the value of the Reps. Name field.', Comment = '%';
                    }
                    field("Location Code"; Rec."Location Code")
                    {
                        Editable = false;
                        ToolTip = 'Specifies the value of the Location Code field.', Comment = '%';
                    }

                }
            }
            part(DORLines; "NTS DOR Subform")
            {
                ApplicationArea = All;
                SubPageLink = "Document No." = field("No.");
            }
            part(DORNonConsumedItems; "NTS DOR Non-Consumed Items SF")
            {
                ApplicationArea = All;
                SubPageLink = "Document No." = field("No.");
            }
        }
    }
    actions
    {
        area(processing)
        {
            group("C&reating")
            {
                Caption = 'C&reating';
                action(CreateSalesOrder)
                {
                    Caption = 'Create Sales Order';
                    Visible = IsCreatedVisible;
                    Image = Create;
                    trigger OnAction()
                    var
                        NexxSpineFunctions: Codeunit "NTS NexxtSpine Functions";
                        SalesHeader: Record "Sales Header";
                        SOExistError: Label 'Sales Order %1 already exist for this %2';
                        ReleasedStatusError: Label 'Status must be Released to Create Sales Order for this %1';
                        DoRHeader: Record "NTS DOR Header";
                    begin
                        if Rec.Status <> Rec.Status::Released then
                            Error(StrSubstNo(ReleasedStatusError, Rec."No."));

                        if not Confirm('Do you want to create the Sales Order from this %1', false, Rec."No.") then
                            exit;

                        DoRHeader.Reset();
                        DoRHeader.SetRange("No.", Rec."No.");
                        DoRHeader.FindFirst();
                        NexxSpineFunctions.PostDoR(DoRHeader, true);
                    end;
                }
            }
            group(DORReleaseGroup)
            {
                Caption = 'Release';
                Image = ReleaseDoc;
                action(Release)
                {
                    ApplicationArea = All;
                    Caption = 'Re&lease';
                    Enabled = Rec.Status <> Rec.Status::Released;
                    Visible = IsReleaseVisible;
                    Image = ReleaseDoc;
                    ShortCutKey = 'Ctrl+F9';
                    ToolTip = 'Release the document to the next stage of processing. You must reopen the document before you can make changes to it.';

                    trigger OnAction()
                    var
                        NTSFunctions: Codeunit "NTS NexxtSpine Functions";
                        DORLine: Record "NTS DOR Line";
                    begin
                        NTSFunctions.GetAndValidateLOTSerialCombo(Rec."Set Name", Rec."Lot No.", Rec."Serial No.");
                        DORLine.Reset();
                        DORLine.SetRange("Document No.", Rec."No.");
                        DORLine.SetRange(Consumed, false);
                        if not DORLine.FindFirst() then
                            NTSFunctions.InsertNonConsumedItems(Rec);

                        DORLine.Reset();
                        DORLine.SetRange("Document No.", Rec."No.");
                        if DORLine.FindSet() then begin
                            repeat
                                NTSFunctions.GetAndValidateLOTSerialCombo(DORLine."Item No.", DORLine."Lot No.", '');
                            until DORLine.Next() = 0;
                        end;
                        Rec.PerformManualRelease();
                        CurrPage.Update();
                    end;
                }
                action(Reopen)
                {
                    ApplicationArea = All;
                    Caption = 'Re&open';
                    Enabled = Rec.Status <> Rec.Status::Open;
                    Visible = IsReopenVisible;
                    Image = ReOpen;
                    ToolTip = 'Reopen the document to change it after it has been approved. Approved documents have the Released status and must be opened before they can be changed.';

                    trigger OnAction()
                    var
                        DORReleaseMgmnt: Codeunit "NTS DOR Release Management";
                    begin
                        DORReleaseMgmnt.PerformManualReopen(Rec);
                    end;
                }
            }
        }
        area(Promoted)
        {
            group(Category_Process)
            {
                Caption = 'Process', Comment = 'Generated from the PromotedActionCategories property index 1.';

                group(Category_Category6)
                {
                    Caption = 'Creating', Comment = 'Generated from the PromotedActionCategories property index 5.';
                    ShowAs = SplitButton;

                    actionref(CreateSalesOrder_Promoted; CreateSalesOrder)
                    {
                    }
                }
                group(Category_Category5)
                {
                    Caption = 'Release', Comment = 'Generated from the PromotedActionCategories property index 4.';
                    ShowAs = SplitButton;

                    actionref(Release_Promoted; Release)
                    {
                    }
                    actionref(Reopen_Promoted; Reopen)
                    {
                    }
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        SetDocNoVisible();
        SetVisibleControls()
    end;

    trigger OnAfterGetCurrRecord()
    begin
    end;

    trigger OnAfterGetRecord()
    begin
    end;

    trigger OnDeleteRecord(): Boolean
    begin
        CurrPage.SaveRecord();
        exit(Rec.ConfirmDeletion());
    end;

    trigger OnInit()
    begin
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
    end;

    procedure SetVisibleControls()
    begin
        if Rec.Posted then begin
            IsReleaseVisible := false;
            IsReopenVisible := false;
            IsCreatedVisible := false;
        end else begin
            IsReleaseVisible := true;
            IsReopenVisible := true;
            IsCreatedVisible := true;
        end;
    end;

    local procedure SetDocNoVisible()
    var
        DocumentNoVisibility: Codeunit DocumentNoVisibility;
    begin
        DocNoVisible := DORDocumentNoIsVisible(Rec."No.");
    end;

    procedure DORDocumentNoIsVisible(DocNo: Code[20]): Boolean
    var
        NoSeries: Record "No. Series";
        SalesNoSeriesSetup: Page "Sales No. Series Setup";
        DocNoSeries: Code[20];
        IsHandled: Boolean;
        IsVisible: Boolean;
        Result: Boolean;
    begin
        if DocNo <> '' then
            exit(false);

        DocNoSeries := DetermineDORSeriesNo();
        NoSeries.Get(DocNoSeries);
        Result := ForceShowNoSeriesForDocNo(DocNoSeries);
        exit(Result);
    end;

    local procedure DetermineDORSeriesNo(): Code[20]
    var
        SalesReceivablesSetup: Record "Sales & Receivables Setup";
    begin
        SalesReceivablesSetup.Get();
        exit(SalesReceivablesSetup."NTS DOR Nos.");
    end;

    procedure ForceShowNoSeriesForDocNo(NoSeriesCode: Code[20]): Boolean
    var
        NoSeries: Record "No. Series";
        NoSeriesRelationship: Record "No. Series Relationship";
        NoSeriesBatch: Codeunit "No. Series - Batch";
        SeriesDate: Date;
    begin
        if not NoSeries.Get(NoSeriesCode) then
            exit(true);

        SeriesDate := WorkDate();
        NoSeriesRelationship.SetRange(Code, NoSeriesCode);
        if not NoSeriesRelationship.IsEmpty() then
            exit(true);

        if NoSeries."Manual Nos." or (NoSeries."Default Nos." = false) then
            exit(true);

        exit(NoSeriesBatch.GetNextNo(NoSeriesCode, SeriesDate, true) = '');
    end;


    var
        DocNoVisible: Boolean;
        IsReleaseVisible: Boolean;
        IsReopenVisible: Boolean;
        IsCreatedVisible: Boolean;
}
