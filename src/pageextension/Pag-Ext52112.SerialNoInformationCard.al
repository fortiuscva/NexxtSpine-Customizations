pageextension 52112 "Serial No. Information Card" extends "Serial No. Information Card"
{
    layout
    {
        addlast(General)
        {
            field("NTS Set Type"; Rec."NTS Set Type")
            {
                ApplicationArea = All;
            }
            group("NTS SerialNo. Notes")
            {
                Caption = 'Serial No. Notes';
                field("NTS Serial No. Notes"; SerialNoNotes)
                {
                    ApplicationArea = Basic, Suite;
                    Importance = Additional;
                    MultiLine = true;
                    ShowCaption = false;

                    trigger OnValidate()
                    begin
                        Rec.SetSerialNoNotes(SerialNoNotes);
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        SerialNoNotes := Rec.GetSerialNoNotes();
    end;

    var
        SerialNoNotes: Text;
}
