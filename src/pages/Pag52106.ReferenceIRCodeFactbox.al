page 52106 "NTS Reference IR Code Factbox"
{
    ApplicationArea = All;
    Caption = 'NTS Reference IR Code Factbox';
    PageType = ListPart;
    SourceTable = "NTS Reference IR Code";
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("IR Number"; Rec."IR Number")
                {
                    ToolTip = 'Specifies the value of the IR Number field.', Comment = '%';
                }
                field("IR Sheet Name"; Rec."IR Sheet Name")
                {
                    ToolTip = 'Specifies the value of the IR Sheet Name field.', Comment = '%';
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(OpenFile)
            {
                ApplicationArea = all;
                Image = Open;
                trigger OnAction()
                begin
                    Hyperlink(rec.Link);
                end;
            }
        }
    }
}
