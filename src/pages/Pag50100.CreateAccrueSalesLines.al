page 50100 "NTS Create Accrue Sales Lines"
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
                Caption = 'Process-ID';
                field("Date"; Rec.Date)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Date field.';
                    Editable = false;
                    trigger OnValidate()
                    begin

                    end;
                }
            }
        }
    }
    trigger OnOpenPage()
    begin
        rec.Init();
        Rec.Date := CalcDate('<CM>', WorkDate());
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
                end;
            else
                clear(rec);
        end;
    end;
}