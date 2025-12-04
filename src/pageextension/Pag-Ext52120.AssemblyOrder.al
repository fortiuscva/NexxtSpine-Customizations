pageextension 52120 "NTS Assembly Order" extends "Assembly Order"
{
    layout
    {
        addlast(Posting)
        {
            field("NTS Posting No."; Rec."Posting No.")
            {
                ApplicationArea = All;
                Visible = false;
                ToolTip = 'Specifies the value of the Posting No. field.', Comment = '%';
            }
            field("NTS Posting No. Series"; Rec."Posting No. Series")
            {
                ApplicationArea = All;
                Visible = false;
                ToolTip = 'Specifies the value of the Posting No. Series field.', Comment = '%';
            }
        }
        addlast(Control2)
        {
            field("NTS Item Tracking Lines"; Rec."NTS Item Tracking Lines")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Item Tracking Lines field.', Comment = '%';
            }
            field("NTS Comments"; Rec.Comment)
            {
                ApplicationArea = All;
                Caption = 'Comment';
                Editable = false;
                Style = StrongAccent;
                StyleExpr = true;
                DrillDown = true;
                ToolTip = 'Indicates if comments exist. Click to view or add comments.';
            }

        }
    }
}
