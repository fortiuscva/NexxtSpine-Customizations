pageextension 52105 "NTS Prod. Order Routing" extends "Prod. Order Routing"
{
    layout
    {
        addafter("Move Time")
        {
            field("NTS IR Sheet 1"; Rec."NTS IR Sheet 1")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the NTS IR Sheet 1 field.';
                Editable = false;
            }
            field("NTS IR Sheet 2"; Rec."NTS IR Sheet 2")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the NTS IR Sheet 2 field.';
                Editable = false;
            }
            field("NTS IR Sheet 3"; Rec."NTS IR Sheet 3")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the NTS IR Sheet 3 field.';
                Editable = false;
            }
        }
        addlast(factboxes)
        {
            part(IRCodesFactbox; "NTS Reference IR Code Factbox")
            {
                Caption = 'Reference IR Code Factbox';
                ApplicationArea = All;
                SubPageLink = "Source Type" = const(5409), "Source Subtype" = field(Status), "Source No." = field("Prod. Order No."), "Source Line No." = field("Routing Reference No.");
            }
        }
    }
    actions
    {
        addafter("Order &Tracking")
        {
            action("NTS Refresh IR/AP Link for Line")
            {
                ApplicationArea = all;
                Caption = 'Refresh IR/AP Link for Line';

                trigger OnAction()
                var
                    ProdOrderRoutingLineRec: Record "Prod. Order Routing Line";
                    NTSRefreshIRReport: Report "NTS Refresh IR Link";
                begin
                    ProdOrderRoutingLineRec.Reset();
                    ProdOrderRoutingLineRec.SetRange(Status, Rec.Status);
                    ProdOrderRoutingLineRec.SetRange("Prod. Order No.", Rec."Prod. Order No.");
                    ProdOrderRoutingLineRec.SetRange("Routing Reference No.", Rec."Routing Reference No.");
                    ProdOrderRoutingLineRec.SetRange("Operation No.", Rec."Operation No.");

                    if not ProdOrderRoutingLineRec.FindFirst() then
                        exit;

                    NTSRefreshIRReport.SetSheetName(
                        Rec."NTS IR Sheet 1",
                        Rec."NTS IR Sheet 2",
                        Rec."NTS IR Sheet 3"
                    );

                    NTSRefreshIRReport.SetTableView(ProdOrderRoutingLineRec);
                    NTSRefreshIRReport.RunModal();
                end;
            }
        }
    }
}