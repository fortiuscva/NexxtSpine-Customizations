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

    }
}
