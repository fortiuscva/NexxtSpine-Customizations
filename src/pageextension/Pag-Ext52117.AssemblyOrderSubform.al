pageextension 52117 "NTS Assembly Order Subform" extends "Assembly Order Subform"
{
    layout
    {
        addfirst(Group)
        {
            field("NTS ItemTrackingLines"; Rec."NTS Item Tracking Lines")
            {
                ApplicationArea = All;
                Editable = false;
                DrillDown = true;
                Style = StrongAccent;
                StyleExpr = true;
                Caption = 'Item Tracking Lines';

                trigger OnDrillDown()
                var
                    AssemblyLineReserve: Codeunit "Assembly Line-Reserve";
                begin
                    if Rec."NTS Item Tracking Lines" then begin
                        AssemblyLineReserve.CallItemTracking(Rec);
                    end;
                end;
            }
        }
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
                Image = Action;
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
