page 52101 "NTS Purchase Reason Codes"
{
    ApplicationArea = All;
    Caption = 'Purchase Reason Codes';
    PageType = List;
    SourceTable = "NTS Purchase Reason Code";
    UsageCategory = Lists;
    DelayedInsert = true;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Code"; Rec."Code")
                {
                    ToolTip = 'Specifies the value of the Code field.';
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.';
                }
            }
        }
    }
}
