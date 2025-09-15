page 52117 "NTS DOR List"
{
    ApplicationArea = All;
    Caption = 'DOR List';
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
                field(Customer; Rec.Customer)
                {
                    ToolTip = 'Specifies the value of the Customer field.', Comment = '%';
                }
                field(Distributor; Rec.Distributor)
                {
                    ToolTip = 'Specifies the value of the Distributor field.', Comment = '%';
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ToolTip = 'Specifies the value of the Posting Date field.', Comment = '%';
                }
                field(Reps; Rec.Reps)
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
                field("No. Series"; Rec."No. Series")
                {
                    ToolTip = 'Specifies the value of the No. Series field.', Comment = '%';
                }

            }
        }
    }
    actions
    {
        area(processing)
        {
            group(DORReleaseGroup)
            {
                Caption = 'Release';
                Image = ReleaseDoc;

                action(ReleaseDOR)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Re&lease';
                    Image = ReleaseDoc;
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

                action(ReopenDOR)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Re&open';
                    Image = ReOpen;
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
}
