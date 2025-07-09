page 52104 "NTS Reference IR Codes"
{
    ApplicationArea = All;
    Caption = 'Reference IR Codes';
    PageType = List;
    SourceTable = "NTS Reference IR Code";
    UsageCategory = Lists;

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
                field("IR Number"; Rec."IR Number")
                {
                    ToolTip = 'Specifies the value of the IR Number field.', Comment = '%';
                }
                field("IR Sheet Name"; Rec."IR Sheet Name")
                {
                    ToolTip = 'Specifies the value of the IR Sheet Name field.', Comment = '%';
                }
                field(Link; Rec.Link)
                {
                    ToolTip = 'Specifies the value of the Link field.', Comment = '%';
                }
                field("Mobile Link"; Rec."Mobile Link")
                {
                    ToolTip = 'Specifies the value of the Mobile Link field.', Comment = '%';
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action("NTS Open Link")
            {
                ApplicationArea = All;
                Caption = 'Open Link';
                Image = Link;

                trigger OnAction()
                begin
                    if Rec.Link <> '' then
                        Hyperlink(Rec.Link)
                    else
                        Message(LineErr);
                end;
            }
        }
    }
    var
        LineErr: Label 'Link is not available';
}