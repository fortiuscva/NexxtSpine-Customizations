page 52102 "NTS IR Codes"
{
    ApplicationArea = All;
    Caption = 'IR Codes';
    PageType = List;
    SourceTable = "NTS IR Code";
    UsageCategory = Lists;
    DelayedInsert = true;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Code"; Rec.Code)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Code field.';
                }
                field("IR Number"; Rec."IR Number")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the IR Number field.';
                    trigger OnValidate()
                    begin
                        CurrPage.Update(true);
                    end;
                }
                field("IR Sheet Name"; Rec."IR Sheet Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the IR Sheet Name field.';
                }
                field(Link; Rec.Link)
                {
                    ToolTip = 'Specifies the value of the Link field.';
                    ApplicationArea = All;
                }
            }
        }
    }
}