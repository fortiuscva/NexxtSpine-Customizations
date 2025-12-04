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
            field("NTS Comments"; ShowComments())
            {
                ApplicationArea = All;
                Caption = ' Comments';
                Editable = false;
                Style = StrongAccent;
                StyleExpr = true;
                DrillDown = true;
                ToolTip = 'Indicates if comments exist. Click to view or add comments.';
                trigger OnDrillDown()
                var
                    AssmCommentLine: Record "Assembly Comment Line";
                begin
                    AssmCommentLine.SetRange("Document Type", Rec."Document Type");
                    AssmCommentLine.SetRange("Document No.", Rec."No.");
                    AssmCommentLine.SetRange("Document Line No.", 0);
                    AssmCommentLine.SetFilter(Comment, '<>%1', '');
                    if AssmCommentLine.FindFirst() then
                        PAGE.Run(PAGE::"Assembly Comment Sheet", AssmCommentLine);
                end;
            }
        }
    }
    procedure ShowComments(): Boolean
    var
        AssmCommentLine: Record "Assembly Comment Line";
    begin
        AssmCommentLine.SetRange("Document Type", Rec."Document Type");
        AssmCommentLine.SetRange("Document No.", Rec."No.");
        AssmCommentLine.SetRange("Document Line No.", 0);
        AssmCommentLine.SetFilter(Comment, '<>%1', '');
        if AssmCommentLine.FindFirst() then
            exit(true);

    end;

}
