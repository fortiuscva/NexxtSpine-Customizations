page 52100 "NTS Create Accrue Sales Lines"
{
    Caption = 'New Accrue Sales Lines';
    PageType = StandardDialog;
    ApplicationArea = all;
    SourceTable = "NTS Accrue Sales Order Lines";
    SourceTableTemporary = true;

    layout
    {
        area(Content)
        {
            group(ProcessID)
            {
                Caption = 'Date';
                field("Date"; Rec.Date)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Date field.';
                    trigger OnValidate()
                    begin
                        Rec.Date := CalcDate('<CM>', WorkDate());
                    end;
                }
            }
        }
    }
    trigger OnOpenPage()
    begin
        rec.Init();
        Rec.Date := CalcDate('<CM>', WorkDate());
        Rec.Insert();
    end;


    trigger OnQueryClosePage(CloseAction: Action): Boolean
    var
        mCUSalesMgtLoc: codeunit "NTS Accrue Sales & Cost Mgmt.";
    begin
        case CloseAction of
            CloseAction::OK:
                begin
                    mCUSalesMgtLoc.AccrueSalesRevenueLines(Rec);
                    mCUSalesMgtLoc.AccrueSalesCOGSLines(Rec);
                    If mCUSalesMgtLoc.PostGeneralJournalAR(Rec) then
                        Message('Sales Revnue has been posted successfully');
                    if mCUSalesMgtLoc.PostGeneralJournalAC(Rec) then
                        Message('Sales Cost has been posted successfully');
                end;
            else
                clear(rec);
        end;
    end;
}