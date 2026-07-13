page 52134 "NTS Manage Time Card Approval"
{
    ApplicationArea = All;
    Caption = 'Manage Time Card Approval';
    PageType = List;
    SourceTable = "SFI Employee Approval Mapping";
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Employee No."; Rec."Employee No.")
                {
                    ToolTip = 'Specifies the managers employee number.';
                }
                field("Employee Name"; Rec."Employee Name")
                {
                    ToolTip = 'Specifies the name of the manager that was set out in the  Employee No. .';
                }
                field("Manages Type"; Rec."Manages Type")
                {
                    ToolTip = 'This indicates what kind of hierarchy association this is. Employee Group';
                }
                field("Manages No."; Rec."Manages No.")
                {
                    ToolTip = 'Manages No.';
                }
                field(ctrlManages; Rec.GetManagesName())
                {
                    ApplicationArea = All;
                    Caption = 'Name';
                    ToolTip = 'Allows users to create the entries to define which employees are approved by which managers.  SFI Employee Approval Mapping';
                }
                field("NTS Unposted Time"; Rec."NTS Unposted Time")
                {
                    ToolTip = 'Specifies the value of the Unposted Time (Hours) field.', Comment = '%';
                }
            }
        }
    }
}
