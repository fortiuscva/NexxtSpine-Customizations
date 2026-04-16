pageextension 52141 "NTS NBT_DIS Disassembly Order" extends "NBT_DIS Disassembly Order"
{
    layout
    {
        addafter(Status)
        {
            field("NTS Disassembly Component Only"; Rec."NTS Disassembly Component Only")
            {
                ApplicationArea = All;
            }
        }
    }
}
