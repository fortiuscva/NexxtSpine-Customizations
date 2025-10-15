page 52122 "NTS Posted DOR Subform"
{
    ApplicationArea = All;
    Caption = 'NTS Posted DOR Subform';
    PageType = ListPart;
    Editable = false;
    SourceTable = "NTS DOR Line";
    AutoSplitKey = true;
    DelayedInsert = true;
    UsageCategory = None;
    SourceTableView = where(Consumed = const(true), Adjustment = const(false));

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Line No."; Rec."Line No.")
                {
                    Visible = false;
                    ToolTip = 'Specifies the value of the Line No. field.', Comment = '%';
                }
                field("Item No."; Rec."Item No.")
                {
                    ToolTip = 'Specifies the value of the Item field.', Comment = '%';
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.', Comment = '%';
                }
                field("Description 2"; Rec."Description 2")
                {
                    ToolTip = 'Specifies the value of the Description 2 field.', Comment = '%';
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
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action("Modify DOR Line")
            {
                Caption = 'Modify DOR Line';
                ApplicationArea = all;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = AdjustEntries;

                trigger OnAction()
                var
                    FromDORLine, ToDORLine : Record "NTS DOR Line";
                    NextLineNo: Integer;
                begin
                    if not Confirm('Do you want to Modify selected DOR Line?') then
                        exit;

                    FromDORLine.Reset();
                    FromDORLine.SetRange("Source DOR No.", Rec."Document No.");
                    FromDORLine.SetRange("Source DOR Line No.", Rec."Line No.");
                    FromDORLine.SetRange("Action Type", FromDORLine."Action Type"::Modification);
                    if FromDORLine.FindFirst() then
                        Error('Modified Line is already exists');

                    CreateNewAdjustmentLine(Rec, true);
                end;
            }
            action("Delete DOR Line")
            {
                Caption = 'Delete DOR Line';
                ApplicationArea = all;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = AdjustEntries;

                trigger OnAction()
                var
                    FromDORLine, ToDORLine : Record "NTS DOR Line";
                    NextLineNo: Integer;
                begin
                    if not Confirm('Do you want to Delete selected DOR Line?') then
                        exit;

                    FromDORLine.Reset();
                    FromDORLine.SetRange("Source DOR No.", Rec."Document No.");
                    FromDORLine.SetRange("Source DOR Line No.", Rec."Line No.");
                    FromDORLine.SetRange("Action Type", FromDORLine."Action Type"::Deletion);
                    if FromDORLine.FindFirst() then
                        Error('Deletion Line is already exists');

                    CreateNewAdjustmentLine(Rec, false);
                end;
            }
        }
    }

    local procedure CreateNewAdjustmentLine(RecPar: Record "NTS DOR Line"; ModifiedLinePar: Boolean)
    var
        FromDORLine, ToDORLine, DORLineRecLcl : Record "NTS DOR Line";
        NextLineNo: Integer;
    begin
        FromDORLine.Reset();
        FromDORLine.SetRange("Document No.", RecPar."Document No.");
        if FromDORLine.FindLast() then
            NextLineNo += FromDORLine."Line No." + 10000
        else
            NextLineNo := 10000;

        ToDORLine.Init();
        ToDORLine.TransferFields(RecPar);
        ToDORLine."Line No." := NextLineNo;
        ToDORLine."Source DOR No." := RecPar."Document No.";
        ToDORLine."Source DOR Line No." := RecPar."Line No.";
        ToDORLine.Adjustment := true;
        ToDORLine.Consumed := false;
        if ModifiedLinePar then
            ToDORLine."Action Type" := ToDORLine."Action Type"::Modification
        else
            ToDORLine."Action Type" := ToDORLine."Action Type"::Deletion;
        ToDORLine."Adjustment Processed" := false;
        ToDORLine.Insert();

        DORLineRecLcl.Reset();
        DORLineRecLcl.SetRange("Source DOR No.", RecPar."Document No.");
        DORLineRecLcl.SetRange("Source DOR Line No.", RecPar."Line No.");
        Page.Run(Page::"NTS DOR Adjusted Items WrkSht", DORLineRecLcl);
    end;
}