page 52119 "NTS DOR"
{
    ApplicationArea = All;
    Caption = 'DOR';
    PageType = Document;
    SourceTable = "NTS DOR Header";
    UsageCategory = None;


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
                field(Customer; Rec.Customer)
                {
                    ToolTip = 'Specifies the value of the Customer field.', Comment = '%';
                }
                field("Set Name"; Rec."Set Name")
                {
                    ToolTip = 'Specifies the value of the Set Name field.', Comment = '%';
                }

                field("Serial Number"; Rec."Serial No.")
                {
                    ToolTip = 'Specifies the value of the Serial Number field.', Comment = '%';
                }
                field("Lot No."; Rec."Lot No.")
                {
                    ToolTip = 'Specifies the value of the Lot No. field.', Comment = '%';
                }
                field(Quantity; Rec.Quantity)
                {
                    ToolTip = 'Specifies the value of the Quantity field.', Comment = '%';
                }

                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the value of the Status field.', Comment = '%';
                }
                field(Surgeon; Rec.Surgeon)
                {
                    ToolTip = 'Specifies the value of the Surgeon field.', Comment = '%';
                }
                field(Distributor; Rec.Distributor)
                {
                    ToolTip = 'Specifies the value of the Distributor field.', Comment = '%';
                }
                field(Reps; Rec.Reps)
                {
                    ToolTip = 'Specifies the value of the Reps field.', Comment = '%';
                }
                field("Surgery Date"; Rec."Surgery Date")
                {
                    ToolTip = 'Specifies the value of the Surgery Date field.', Comment = '%';
                }
            }
            part(DoRLinesPart; "NTS DOR Subform")
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
            group(Post)
            {
                Caption = 'Post';
                action(PostDoR)
                {
                    Caption = 'Post';
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    trigger OnAction()
                    var
                        NexxSpineFunctions: Codeunit "NTS NexxtSpine Functions";
                        SalesHeader: Record "Sales Header";
                        SOExistError: Label 'Sales Order %1 already exist for this %2';
                        ReleasedStatusError: Label 'Status must be Released to Post this %1';
                    begin
                        if Rec.Status = Rec.Status::Posted then begin
                            SalesHeader.Reset();
                            SalesHeader.SetRange("NTS DoR Number", Rec."No.");
                            if SalesHeader.FindFirst() then
                                Error(StrSubstNo(SOExistError, SalesHeader."No.", Rec."No."));
                        end;
                        if not Confirm('Do you want to post the DOR %1', false, Rec."No.") then
                            exit;
                        if Rec.Status = Rec.Status::Released then
                            NexxSpineFunctions.PostDoR(Rec)
                        else
                            Error(StrSubstNo(ReleasedStatusError, Rec."No."));
                    end;
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        SetDocNoVisible();
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
}
