page 52127 "NTS DOR Adjusted Items SF"
{
    ApplicationArea = All;
    Caption = 'Adjustment Entries';
    PageType = ListPart;
    SourceTable = "NTS DOR Line";
    AutoSplitKey = true;
    DelayedInsert = true;
    UsageCategory = None;
    SourceTableView = where(Adjustment = const(true));

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Item No."; Rec."Item No.")
                {
                    ToolTip = 'Specifies the value of the Item field.', Comment = '%';
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.', Comment = '%';
                    Editable = false;
                }
                field("Description 2"; Rec."Description 2")
                {
                    ToolTip = 'Specifies the value of the Description 2 field.', Comment = '%';
                    Editable = false;
                    Visible = false;
                }
                field("Lot No."; Rec."Lot No.")
                {
                    ToolTip = 'Specifies the value of the Lot Number field.', Comment = '%';
                }
                field(Quantity; Rec.Quantity)
                {
                    ToolTip = 'Specifies the value of the Quantity field.', Comment = '%';
                }
                field("Action Type"; Rec."Action Type")
                {
                    ToolTip = 'Specifies the value of the Action Type field.', Comment = '%';
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(ApplyAdjustments)
            {
                Caption = 'Apply Adjustments';
                ApplicationArea = All;
                trigger OnAction()
                begin
                    if Confirm(ProceedAndApplyAdjustmentsMsg) then begin
                        DORHeader.get(Rec."Document No.");
                        NexxtSpineFunctions.ApplyPostedDORAdjustments(DORHeader);
                    end;
                end;
            }
        }
    }

    var
        NexxtSpineFunctions: Codeunit "NTS NexxtSpine Functions";
        DORHeader: Record "NTS DOR Header";
        ProceedAndApplyAdjustmentsMsg: Label 'Do you want to proceed and apply adjustments to open sales order?';
}
