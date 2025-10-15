page 52128 "NTS DOR Adjusted Items WrkSht"
{
    ApplicationArea = All;
    Caption = 'Adjustment Entries';
    PageType = List;
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
                field("Document No."; Rec."Document No.")
                {
                    ToolTip = 'Specifies the value of the Document No. field.', Comment = '%';
                    Visible = false;
                }
                field("Line No."; Rec."Line No.")
                {
                    ToolTip = 'Specifies the value of the Line No. field.', Comment = '%';
                    Visible = false;
                }
                field(Consumed; Rec.Consumed)
                {
                    ToolTip = 'Specifies the value of the Consumable field.', Comment = '%';
                    Visible = false;
                }
                field(Adjustment; Rec.Adjustment)
                {
                    ToolTip = 'Specifies the value of the Adjustment field.', Comment = '%';
                    Visible = false;
                }

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
                field("Serial No."; Rec."Serial No.")
                {
                    ToolTip = 'Specifies the value of the Serial No. field.', Comment = '%';
                    Visible = false;
                }

                field(Quantity; Rec.Quantity)
                {
                    ToolTip = 'Specifies the value of the Quantity field.', Comment = '%';
                }
            }
        }
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec.Adjustment := true;
        if Rec."Action Type" = Rec."Action Type"::" " then
            Rec."Action Type" := Rec."Action Type"::Insertion;
    end;

    trigger OnModifyRecord(): Boolean
    begin
        Rec.TestField("Adjustment Processed", false);
    end;

    trigger OnDeleteRecord(): Boolean
    begin
        Rec.TestField("Adjustment Processed", false);
    end;
}
