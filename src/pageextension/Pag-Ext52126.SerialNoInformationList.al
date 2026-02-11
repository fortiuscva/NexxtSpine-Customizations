pageextension 52126 "Serial No. Information List" extends "Serial No. Information List"
{
    layout
    {
        addlast(Control1)
        {

            field("NTS Set Type"; Rec."NTS Set Type")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Set Type field.', Comment = '%';
            }
            field("NTS Serial No. Notes"; Rec."NTS Serial No. Notes Exists")
            {
                ApplicationArea = All;
                Caption = 'Serial No. Notes';
                ToolTip = 'Specifies the value of the Serial No. Notes field.', Comment = '%';
            }

        }
    }
    trigger OnOpenPage()
    begin
        Rec.HasSerialNoNotes();
    end;

    trigger OnAfterGetRecord()
    begin
        Rec.HasSerialNoNotes();
    end;

}
