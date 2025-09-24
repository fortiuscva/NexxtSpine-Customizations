page 52123 "NTS DOR Non-Consumed Items"
{
    ApplicationArea = All;
    Caption = 'Non-Consumed Items';
    PageType = ListPart;
    SourceTable = "NTS DOR Line";
    AutoSplitKey = true;
    DelayedInsert = true;
    UsageCategory = None;
    SourceTableView = where(Consumed = const(false));

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
                    Visible = false;
                }
            }
        }
    }
}
