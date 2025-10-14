page 52115 "NTS Surgeon List"
{
    ApplicationArea = All;
    Caption = 'Surgeon';
    PageType = List;
    SourceTable = "NTS Surgeon";
    UsageCategory = Lists;
    DataCaptionFields = Name;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Surgeon Name"; Rec.Code)
                {
                    ToolTip = 'Specifies the value of the Surgeon Name field.', Comment = '%';
                }
                field(Name; Rec.Name)
                {
                    ToolTip = 'Specifies the value of the Name field.', Comment = '%';
                }
            }
        }
    }
}
