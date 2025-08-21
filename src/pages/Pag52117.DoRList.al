page 52117 "NTS DoR List"
{
    ApplicationArea = All;
    Caption = 'NTS DoR List';
    PageType = List;
    SourceTable = "NTS DoR Line";
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("DoR Number"; Rec."DoR Number")
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
