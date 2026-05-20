page 52132 "Sales Line Prod Family Summary"
{
    ApplicationArea = All;
    Caption = 'Sales Line Product Family Summary';
    PageType = List;
    SourceTable = "Sales Product Family Summary";
    SourceTableView = where("Document Type" = const(Order));
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Document No."; Rec."Document No.")
                {
                    ToolTip = 'Specifies the value of the Document No. field.', Comment = '%';
                }
                field("Family 1"; Rec."Family 1")
                {
                    ToolTip = 'Specifies the value of the Family 1 field.', Comment = '%';
                }
                field("Amount 1"; Rec."Amount 1")
                {
                    ToolTip = 'Specifies the value of the Amount 1 field.', Comment = '%';
                }
                field("Family 2"; Rec."Family 2")
                {
                    ToolTip = 'Specifies the value of the Family 2 field.', Comment = '%';
                }
                field("Amount 2"; Rec."Amount 2")
                {
                    ToolTip = 'Specifies the value of the Amount 2 field.', Comment = '%';
                }
                field("Family 3"; Rec."Family 3")
                {
                    ToolTip = 'Specifies the value of the Family 3 field.', Comment = '%';
                }
                field("Amount 3"; Rec."Amount 3")
                {
                    ToolTip = 'Specifies the value of the Amount 3 field.', Comment = '%';
                }
                field("Family 4"; Rec."Family 4")
                {
                    ToolTip = 'Specifies the value of the Family 4 field.', Comment = '%';
                }
                field("Amount 4"; Rec."Amount 4")
                {
                    ToolTip = 'Specifies the value of the Amount 4 field.', Comment = '%';
                }
            }
        }
    }
}
