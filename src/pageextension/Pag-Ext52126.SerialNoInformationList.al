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
            field("NTS Serial No. Notes"; SerialNoNotesExists)
            {
                ApplicationArea = All;
                Caption = 'Serial No. Notes';
                ToolTip = 'Specifies the value of the Serial No. Notes field.', Comment = '%';
            }

        }
    }
    trigger OnAfterGetRecord()
    begin
        SerialNoNotes := '';
        SerialNoNotesExists := false;
        SerialNoNotes := Rec.GetSerialNoNotes();
        if SerialNoNotes <> '' then
            SerialNoNotesExists := true;
    end;

    var
        SerialNoNotes: Text;
        SerialNoNotesExists: Boolean;
}
