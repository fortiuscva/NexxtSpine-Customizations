pageextension 52141 "NTS NBT_DIS Disassembly Order" extends "NBT_DIS Disassembly Order"
{
    layout
    {
        addafter(Status)
        {
            field("NTS Disassembly Component Only"; Rec."NTS Disassembly Component Only")
            {
                ApplicationArea = All;
                trigger OnValidate()
                var
                    AssemblyLineMgt: Codeunit "Assembly Line Management";
                    AssemblyLine: Record "Assembly Line";
                begin
                    if not Rec."NTS Disassembly Component Only" then begin
                        Clear(Rec."NTS Serial No.");
                        AssemblyLine.Reset();
                        AssemblyLine.SetRange("Document Type", Rec."Document Type");
                        AssemblyLine.SetRange("Document No.", Rec."No.");
                        if not AssemblyLine.IsEmpty then
                            AssemblyLine.DeleteAll(true);

                        AssemblyLineMgt.UpdateAssemblyLines(Rec, xRec, 0, true, Rec.FieldNo("NTS Disassembly Component Only"), 0);

                        CurrPage.Update();
                    end;
                end;
            }
            field("NTS Serial No."; Rec."NTS Serial No.")
            {
                ApplicationArea = All;
            }
        }
    }
}
