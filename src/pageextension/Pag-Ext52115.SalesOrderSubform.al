pageextension 52115 "NTS Sales Order Subform" extends "Sales Order Subform"
{
    layout
    {
        addfirst(Control1)
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
            field("NTS Set Name"; Rec."NTS Set Name")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Set Name field.', Comment = '%';
            }
            field("NTS Set Lot No."; Rec."NTS Set Lot No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Set Lot No. field.', Comment = '%';
                Visible = false;
            }
            field("NTS Set Serial No."; Rec."NTS Set Serial No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Set Serial No. field.', Comment = '%';
            }
        }
        addlast(Control1)
        {
            field("NTS Reps."; Rec."NTS Reps.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Reps. field.', Comment = '%';
                Visible = false;
            }
            field("NTS Surgeon"; Rec."NTS Surgeon")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Surgeon field.', Comment = '%';
                Visible = false;
            }
            field("NTS Lot Number"; Rec."NTS Lot Number")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Lot Number field.', Comment = '%';
                Visible = false;
            }
            field("NTS Reps. Name"; Rec."NTS Reps. Name")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Reps. Name field.', Comment = '%';
                Visible = false;
            }
            field("NTS Distributor"; Rec."NTS Distributor")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Distributor field.', Comment = '%';
                Visible = false;
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
                    SalesLineReserve: Codeunit "Sales Line-Reserve";
                begin
                    if ItemTrackingFlag then begin
                        SalesLineReserve.CallItemTracking(Rec);
                    end;
                end;
            }
        }
    }



    trigger OnAfterGetRecord()
    var
        ReservEntry: Record "Reservation Entry";
    begin
        ItemTrackingFlag := false;
        if Rec."Document No." <> '' then begin
            ReservEntry.SetRange("Source Type", DATABASE::"Sales Line");
            ReservEntry.SetRange("Source ID", Rec."Document No.");
            ReservEntry.SetRange("Source Ref. No.", Rec."Line No.");
            ItemTrackingFlag := ReservEntry.FindFirst();
        end;
    end;

    var
        ItemTrackingFlag: Boolean;
}
