page 52108 "NTS Distributor Hospital"
{
    ApplicationArea = All;
    Caption = 'Distributor Hospital';
    PageType = List;
    SourceTable = "NTS Distributor Hospital";
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Hospital No."; Rec."Hospital No.")
                {
                    ToolTip = 'Specifies the value of the Hospital No. field.', Comment = '%';
                }
            }
        }
    }
}
