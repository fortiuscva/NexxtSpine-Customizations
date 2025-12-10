pageextension 52107 "NTS Released Production Order" extends "Released Production Order"
{
    layout
    {
        modify(Control1900383207)
        {
            Visible = true;
        }
        addlast(General)
        {
            field("Material #1"; Rec."Material #1")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Material #1 field.', Comment = '%';
            }
            field("Material #2"; Rec."Material #2")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Material #2 field.', Comment = '%';
            }
            field("Material #3"; Rec."Material #3")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Material #3 field.', Comment = '%';
            }
            field("Material #4"; Rec."Material #4")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Material #4 field.', Comment = '%';
            }
            field("Material #5"; Rec."Material #5")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Material #5 field.', Comment = '%';
            }
            field("NTS System Name"; Rec."NTS System Name")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the System Name field.', Comment = '%';
            }
            field("NTS Height/Depth"; Rec."NTS Height/Depth")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Height/Depth field.', Comment = '%';
            }
            field("NTS IFU Number"; Rec."NTS IFU Number")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the IFU Number field.', Comment = '%';
            }
            field("NTS Sterile Product"; Rec."NTS Sterile Product")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Sterile Product field.', Comment = '%';
            }
        }
    }
    actions
    {
        addafter(RefreshProductionOrder)
        {
            action("NTS Refresh IR/AP Link for Line")
            {
                ApplicationArea = all;
                Caption = 'Refresh IR/AP Link for Line';

                trigger OnAction()
                var
                    ProdOrderRec: Record "Production Order";
                    NTSRefreshIRReport: Report "NTS Refresh IR Link";
                begin
                    ProdOrderRec.Reset();
                    ProdOrderRec.SetRange(Status, Rec.Status);
                    ProdOrderRec.SetRange("No.", Rec."No.");
                    ProdOrderRec.FindFirst();

                    NTSRefreshIRReport.SetTableView(ProdOrderRec);
                    NTSRefreshIRReport.RunModal();
                end;
            }
        }
        addafter(RefreshProductionOrder_Promoted)
        {
            Actionref(RefreshIRIPLink; "NTS Refresh IR/AP Link for Line")
            { }
        }
    }
}