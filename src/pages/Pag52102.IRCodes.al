page 52102 "NTS IR Codes"
{
    ApplicationArea = All;
    Caption = 'IR/IP Codes';
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
                field("File Name"; Rec."File Name")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the File Name field.';
                }
                field(Link; Rec.Link)
                {
                    ToolTip = 'Specifies the value of the Link field.';
                    ApplicationArea = All;
                }
                field("IR/IP Type"; Rec."IR/IP Type")
                {
                    ApplicationArea = all;
                }
            }
        }
    }

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    var
        IRCodeRec: Record "NTS IR Code";
    begin
        IRCodeRec.SetRange("IR/IP Type", IRCodeRec."IR/IP Type"::" ");
        if not IRCodeRec.IsEmpty() then
            if Confirm('Do you want to verify IR/IP Type with Blank Values.', false) then
                exit(false);
    end;
}