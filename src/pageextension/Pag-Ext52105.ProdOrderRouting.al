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

                trigger OnValidate()
                begin
                    InsertManualLog(Rec."NTS IR Sheet 1");
                    Rec.CopyIRCodesToReferenceIRCodes(Rec."NTS IR Sheet 1", true);
                end;
            }
            field("NTS IR Sheet 2"; Rec."NTS IR Sheet 2")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the NTS IR Sheet 2 field.';
                trigger OnValidate()
                begin
                    InsertManualLog(Rec."NTS IR Sheet 2");
                    Rec.CopyIRCodesToReferenceIRCodes(Rec."NTS IR Sheet 2", true);
                end;
            }
            field("NTS IR Sheet 3"; Rec."NTS IR Sheet 3")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the NTS IR Sheet 3 field.';

                trigger OnValidate()
                begin
                    InsertManualLog(Rec."NTS IR Sheet 3");
                    Rec.CopyIRCodesToReferenceIRCodes(Rec."NTS IR Sheet 3", true);
                end;
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
            action("NTS Refresh IR/IP links")
            {
                ApplicationArea = all;
                Caption = 'Refresh IR/IP links';

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

    procedure InsertManualLog(IRSheetPar: Code[20])
    var
        ManualIRLog: Record "NTS Manual IR Sheet Log";
    begin
        ManualIRLog.Init();
        ManualIRLog."Source Type" := Database::"Prod. Order Routing Line";
        ManualIRLog."Source Subtype" := Rec.Status;
        ManualIRLog."Source No." := Rec."Prod. Order No.";
        ManualIRLog."Source Line No." := Rec."Routing Reference No.";
        ManualIRLog."Operation No." := Rec."Operation No.";
        ManualIRLog."IR Code" := IRSheetPar;
        ManualIRLog."Entered By" := UserId;
        ManualIRLog."Entered On" := CurrentDateTime;
        ManualIRLog.Insert();
    end;
}