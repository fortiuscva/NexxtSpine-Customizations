page 52104 "NTS Reference IR Codes"
{
    ApplicationArea = All;
    Caption = 'Reference IR/IP Codes';
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
                field("Template Link"; Rec."Template Link")
                {
                    ToolTip = 'Specifies the value of the Template Link field.', Comment = '%';
                }
                field("Sharepoint Link"; Rec."Sharepoint Link")
                {
                    ToolTip = 'Specifies the value of the Sharepoint Link field.', Comment = '%';
                }
                field("Mobile Link"; Rec."Mobile Link")
                {
                    ToolTip = 'Specifies the value of the Mobile Link field.', Comment = '%';
                }
                field("Manual Entry"; Rec."Manual Entry")
                {
                    ToolTip = 'Specifies the value of the Manual Entry field.', Comment = '%';
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
                    if Rec."Sharepoint Link" <> '' then
                        Hyperlink(Rec."Sharepoint Link")
                    else
                        Message(LineErr);
                end;
            }
        }
    }
    var
        LineErr: Label 'Link is not available';
}