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

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Line No."; Rec."Line No.")
                {
                    ToolTip = 'Specifies the value of the Line No. field.', Comment = '%';
                }
                field("Item No."; Rec."Item No.")
                {
                    ToolTip = 'Specifies the value of the Item field.', Comment = '%';
                }
                field("Lot No."; Rec."Lot No.")
                {
                    ToolTip = 'Specifies the value of the Lot Number field.', Comment = '%';
                }
                field(Quantity; Rec.Quantity)
                {
                    ToolTip = 'Specifies the value of the Quantity field.', Comment = '%';
                }
                field(Consumed; Rec.Consumed)
                {
                    ToolTip = 'Specifies the value of the Consumable field.', Comment = '%';
                }
            }
        }
    }
}
