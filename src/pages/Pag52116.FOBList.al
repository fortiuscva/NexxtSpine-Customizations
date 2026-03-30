page 52116 "NTS FOB List"
{
    ApplicationArea = All;
    Caption = 'FOB';
    PageType = List;
    SourceTable = "NTS FOB";
    UsageCategory = Lists;
    DataCaptionFields = Description;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Code"; Rec."Code")
                {
                    ToolTip = 'Specifies the value of the Code field.', Comment = '%';
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.', Comment = '%';
                }
            }
        }
    }
}
