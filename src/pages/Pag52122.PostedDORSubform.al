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
    SourceTableView = where(Consumed = const(true));

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
}
