page 52129 "NTS OneDrive File Staging"
{
    ApplicationArea = All;
    Caption = 'NTS OneDrive File Staging';
    PageType = List;
    SourceTable = "NTS OneDrive File Staging";
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ToolTip = 'Specifies the value of the Entry No. field.', Comment = '%';
                }
                field("File Name"; Rec."File Name")
                {
                    ToolTip = 'Specifies the value of the File Name field.', Comment = '%';
                }
                field("File Extension"; Rec."File Extension")
                {
                    ToolTip = 'Specifies the value of the File Extension field.', Comment = '%';
                }
                field("OneDrive Item Id"; Rec."OneDrive Item Id")
                {
                    ToolTip = 'Specifies the value of the OneDrive Item Id field.', Comment = '%';
                }
                field(Processed; Rec.Processed)
                {
                    ToolTip = 'Specifies the value of the Processed field.', Comment = '%';
                }
                field("Error Message"; Rec."Error Message")
                {
                    ToolTip = 'Specifies the value of the Error Message field.', Comment = '%';
                }
                field("File Content"; Rec."File Content")
                {
                    ToolTip = 'Specifies the value of the File Content field.', Comment = '%';
                }
                field("Created At"; Rec."Created At")
                {
                    ToolTip = 'Specifies the value of the Created At field.', Comment = '%';
                }
            }
        }
    }
}
