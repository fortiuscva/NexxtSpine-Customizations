pageextension 52107 "NTS Released Production Order" extends "Released Production Order"
{
    layout
    {
        modify(Control1900383207)
        {
            Visible = true;
        }
        addlast(content)
        {
            field("NTS System Name"; Rec."NTS System Name")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the System Name field.', Comment = '%';
            }
            field("NTS Height/Depth"; Rec."NTS Height/Depth")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Height/Depth field.', Comment = '%';
            }
            field("NTS IFU Number"; Rec."NTS IFU Number")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the IFU Number field.', Comment = '%';
            }
            field("NTS Sterile Product"; Rec."NTS Sterile Product")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Sterile Product field.', Comment = '%';
            }
        }
    }
}