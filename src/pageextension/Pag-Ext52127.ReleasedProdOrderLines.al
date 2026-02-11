pageextension 52127 "NTS Released Prod. Order Lines" extends "Released Prod. Order Lines"
{
    layout
    {
        addlast(Control1)
        {
            field("Material #1"; Rec."Material #1")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Material #1 field.', Comment = '%';
                Editable = false;
            }
            field("Material #2"; Rec."Material #2")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Material #2 field.', Comment = '%';
                Editable = false;
            }
            field("Material #3"; Rec."Material #3")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Material #3 field.', Comment = '%';
                Editable = false;
            }
            field("Material #4"; Rec."Material #4")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Material #4 field.', Comment = '%';
                Editable = false;
            }
            field("Material #5"; Rec."Material #5")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Material #5 field.', Comment = '%';
                Editable = false;
            }
            field("NTS System Name"; Rec."NTS System Name")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the System Name field.', Comment = '%';
                Editable = false;
            }
            field("NTS Height/Depth"; Rec."NTS Height/Depth")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Height/Depth field.', Comment = '%';
                Editable = false;
            }
            field("NTS IFU Number"; Rec."NTS IFU Number")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the IFU Number field.', Comment = '%';
                Editable = false;
            }
            field("NTS Sterile Product"; Rec."NTS Sterile Product")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Sterile Product field.', Comment = '%';
                Editable = false;
            }
            field("NTS GTIN"; Rec."NTS GTIN")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the GTIN field.', Comment = '%';
                Editable = false;
            }
        }
        addfirst(Control1)
        {
            field("NTS Item Tracking Exists"; Rec."NTS Item Tracking Exists")
            {
                ApplicationArea = All;
                Editable = false;
                DrillDown = true;
                Style = StrongAccent;
                StyleExpr = true;
                Caption = 'Item Tracking Exists';

                trigger OnDrillDown()
                var
                    ProdOrderLineReserve: Codeunit "Prod. Order Line-Reserve";
                begin
                    if Rec."NTS Item Tracking Exists" then
                        ProdOrderLineReserve.CallItemTracking(Rec)
                    else
                        Rec.OpenItemTrackingLines();
                end;
            }
            field("NTS Lot No."; Rec."NTS Lot No.")
            {
                ApplicationArea = All;
                Caption = 'Lot No.';
            }
            field("NTS Serial No."; Rec."NTS Serial No.")
            {
                ApplicationArea = All;
                Caption = 'Serial No.';
            }
            field("NTS Expiration Date"; Rec."NTS Expiration Date")
            {
                ApplicationArea = All;
                Caption = 'Expiration Date';
            }
        }
    }
}
