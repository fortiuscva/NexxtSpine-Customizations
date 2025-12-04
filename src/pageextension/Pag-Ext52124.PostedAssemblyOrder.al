pageextension 52124 "NTS Posted Assembly Order" extends "Posted Assembly Order"
{
    layout
    {
        addlast(General)
        {
            field("NTS Comment"; Rec.Comment)
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
