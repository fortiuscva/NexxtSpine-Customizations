page 52115 "NTS Surgeon List"
{
    ApplicationArea = All;
    Caption = 'Surgeon';
    PageType = List;
    SourceTable = "NTS Surgeon";
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Surgeon Name"; Rec."Surgeon Name")
                {
                    ToolTip = 'Specifies the value of the Surgeon Name field.', Comment = '%';
                }
            }
        }
    }
}
