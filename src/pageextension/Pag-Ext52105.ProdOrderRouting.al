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
                    ProdOrderRec: Record "Production Order";
                    NTSRefreshIRReport: Report "NTS Refresh IR Link";
                begin
                    ProdOrderRec.Reset();
                    ProdOrderRec.SetRange(Status, Rec.Status);
                    ProdOrderRec.SetRange("No.", Rec."Prod. Order No.");
                    ProdOrderRec.FindFirst();

                    NTSRefreshIRReport.SetTableView(ProdOrderRec);
                    NTSRefreshIRReport.RunModal();
                end;
            }
        }
    }
}