page 52118 "NTS DOR Subform"
{
    ApplicationArea = All;
    Caption = 'DOR Subform';
    PageType = ListPart;
    SourceTable = "NTS DOR Line";
    AutoSplitKey = true;
    DelayedInsert = true;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("DoR Number"; Rec."Document No.")
                {
                    ToolTip = 'Specifies the value of the DoR Number field.', Comment = '%';
                }
                field("Item No."; Rec."Item No.")
                {
                    ToolTip = 'Specifies the value of the Item field.', Comment = '%';
                }
                field("Lot Number"; Rec."Lot Number")
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
