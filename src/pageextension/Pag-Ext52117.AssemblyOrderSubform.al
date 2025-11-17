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
            field("NTS ItemTrackingLines"; ItemTrackingFlag)
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
                    if ItemTrackingFlag then begin
                        AssemblyLineReserve.CallItemTracking(Rec);
                    end;
                end;
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
                trigger OnAction()
                var
                    AsmHdr: Record "Assembly Header";
                    UpdateLocationonAssemblyLine: report "Update Location on Ass. Lines";
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
    trigger OnAfterGetRecord()
    var
        ReservEntry: Record "Reservation Entry";
    begin
        ItemTrackingFlag := false;
        ReservEntry.SetRange("Source Type", DATABASE::"Assembly Line");
        ReservEntry.SetRange("Source ID", Rec."Document No.");
        ReservEntry.SetRange("Source Ref. No.", Rec."Line No.");
        ItemTrackingFlag := ReservEntry.FindFirst();
    end;

    var
        ItemTrackingFlag: Boolean;
}
