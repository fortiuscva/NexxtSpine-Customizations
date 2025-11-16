pageextension 52117 "NTS Assembly Order Subform" extends "Assembly Order Subform"
{
    layout
    {
        addlast(content)
        {
            field("NTS DOR No."; Rec."NTS DOR No.")
            {
                Editable = false;
                ApplicationArea = all;
            }
            field("NTS DOR Line No."; Rec."NTS DOR Line No.")
            {
                Editable = false;
                ApplicationArea = all;
            }
        }
    }
    actions
    {
        addlast(processing)
        {
            action("NTS UpdateLocation")
            {
                Caption = 'Update Location';
                ApplicationArea = All;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                Image = Allocate;
                trigger OnAction()
                var
                    AsmHdr: Record "Assembly Header";
                    UpdateLocationonAssemblyLine: report "Update Location on Assm. Lines";
                begin
                    if not AsmHdr.Get(Rec."Document Type"::Order, Rec."Document No.") then
                        exit;
                    AsmHdr.SetRange("No.", Rec."Document No.");
                    UpdateLocationonAssemblyLine.SetTableView(AsmHdr);
                    UpdateLocationonAssemblyLine.SetAsmHeader(AsmHdr);
                    UpdateLocationonAssemblyLine.RunModal();
                end;
            }
        }
    }
}
