pageextension 52144 "NBT_DIS DisassemblyOrdSubform" extends "NBT_DIS DisassemblyOrdSubform"
{
    layout
    {
        addafter(Quantity)
        {
            field("NTS Qty Reversed"; Rec."NTS Qty Reversed")
            {
                ApplicationArea = All;
            }
        }
    }
}