page 52114 "NTS Patent"
{
    Caption = 'Patent';
    SourceTable = "NTS Patent";
    ApplicationArea = All;
    PageType = List;
    UsageCategory = Lists;


    layout
    {
        area(Content)
        {
            repeater(group)
            {
                field("Code"; Rec."Code")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Code field.', Comment = '%';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Description field.', Comment = '%';
                }
            }
        }
    }
}
