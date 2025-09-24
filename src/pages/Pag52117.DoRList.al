page 52117 "NTS DOR List"
{
    ApplicationArea = All;
    Caption = 'DORs';
    PageType = List;
    Editable = false;
    SourceTable = "NTS DOR Header";
    CardPageId = "NTS DOR";
    UsageCategory = Lists;
    SourceTableView = where(Posted = filter(false));


    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("DoR Number"; Rec."No.")
                {
                    ToolTip = 'Specifies the value of the DoR Number field.', Comment = '%';
                }
                field(Customer; Rec."Customer No.")
                {
                    ToolTip = 'Specifies the value of the Customer field.', Comment = '%';
                }
                field("Customer Name"; Rec."Customer Name")
                {
                    ToolTip = 'Specifies the value of the Customer Name field.', Comment = '%';
                }
                field(Distributor; Rec.Distributor)
                {
                    ToolTip = 'Specifies the value of the Distributor field.', Comment = '%';
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ToolTip = 'Specifies the value of the Posting Date field.', Comment = '%';
                }
                field(Reps; Rec."Reps.")
                {
                    ToolTip = 'Specifies the value of the Reps field.', Comment = '%';
                }
                field("Serial Number"; Rec."Serial No.")
                {
                    ToolTip = 'Specifies the value of the Serial Number field.', Comment = '%';
                }
                field("Set Name"; Rec."Set Name")
                {
                    ToolTip = 'Specifies the value of the Set Name field.', Comment = '%';
                }
                field("Set Description"; Rec."Set Description")
                {
                    ToolTip = 'Specifies the value of the Set Description field.', Comment = '%';
                }

                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the value of the Status field.', Comment = '%';
                }
                field(Surgeon; Rec.Surgeon)
                {
                    ToolTip = 'Specifies the value of the Surgeon field.', Comment = '%';
                }
                field("Surgery Date"; Rec."Surgery Date")
                {
                    ToolTip = 'Specifies the value of the Surgery Date field.', Comment = '%';
                }
            }
        }
    }
    actions
    {
        area(processing)
        {
            group("P&osting")
            {
                Caption = 'P&osting';
                action(Post)
                {
                    Caption = 'Post';
                    Visible = IsPostedVisible;
                    trigger OnAction()
                    var
                        NexxSpineFunctions: Codeunit "NTS NexxtSpine Functions";
                        SalesHeader: Record "Sales Header";
                        SOExistError: Label 'Sales Order %1 already exist for this %2';
                        ReleasedStatusError: Label 'Status must be Released to Post this %1';
                    begin
                        if Rec.Status <> Rec.Status::Released then
                            Error(StrSubstNo(ReleasedStatusError, Rec."No."));

                        if not Confirm('Do you want to post the %1', false, Rec."No.") then
                            exit;

                        NexxSpineFunctions.PostDoR(Rec)
                    end;
                }
                group(DORReleaseGroup)
                {
                    Caption = 'Release';
                    Image = ReleaseDoc;

                    action(Release)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Re&lease';
                        Image = ReleaseDoc;
                        Enabled = Rec.Status <> Rec.Status::Released;
                        Visible = IsReleaseVisible;
                        ShortCutKey = 'Ctrl+F9';
                        ToolTip = 'Release the DOR document to the next stage of processing. You must reopen the document before you can make changes to it.';

                        trigger OnAction()
                        var
                            DorHeader: Record "NTS DOR Header";
                        begin
                            CurrPage.SetSelectionFilter(DorHeader);
                            Rec.PerformManualRelease(DorHeader);
                            CurrPage.Update(false);
                        end;
                    }

                    action(Reopen)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Re&open';
                        Image = ReOpen;
                        Enabled = Rec.Status <> Rec.Status::Open;
                        Visible = IsReopenVisible;
                        ToolTip = 'Reopen the DOR document to change it after it has been approved. Approved DOR documents have the Released status and must be opened before they can be changed.';

                        trigger OnAction()
                        var
                            DorHeader: Record "NTS DOR Header";
                        begin
                            CurrPage.SetSelectionFilter(DorHeader);
                            Rec.PerformManualReopen(DorHeader);
                            CurrPage.Update(false);
                        end;
                    }
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
                    Caption = 'Posting', Comment = 'Generated from the PromotedActionCategories property index 5.';
                    ShowAs = SplitButton;

                    actionref(Post_Promoted; Post)
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
    trigger OnAfterGetRecord()
    begin
        SetVisibleControls()
    end;

    procedure SetVisibleControls()
    begin
        if Rec.Posted then begin
            IsReleaseVisible := false;
            IsReopenVisible := false;
            IsPostedVisible := false;
        end else begin
            IsReleaseVisible := true;
            IsReopenVisible := true;
            IsPostedVisible := true;
        end;
    end;

    var
        IsReleaseVisible: Boolean;
        IsReopenVisible: Boolean;
        IsPostedVisible: Boolean;
}
