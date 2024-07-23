tableextension 52112 "NTS Prod. Order Routing Line" extends "Prod. Order Routing Line"
{
    fields
    {
        field(52100; "NTS IR Sheet 1"; Code[20])
        {
            Caption = 'IR Sheet 1';
            DataClassification = ToBeClassified;
            TableRelation = "NTS Reference IR Code";

            trigger OnValidate()
            begin
                CopyIRCodesToReferenceIRCodes("NTS IR Sheet 1");
            end;
        }
        field(52101; "NTS IR Sheet 2"; Code[20])
        {
            Caption = 'IR Sheet 2';
            DataClassification = ToBeClassified;
            TableRelation = "NTS Reference IR Code";

            trigger OnValidate()
            begin
                CopyIRCodesToReferenceIRCodes("NTS IR Sheet 2");
            end;
        }
        field(52102; "NTS IR Sheet 3"; Code[20])
        {
            Caption = 'IR Sheet 3';
            DataClassification = ToBeClassified;
            TableRelation = "NTS Reference IR Code";

            trigger OnValidate()
            begin
                CopyIRCodesToReferenceIRCodes("NTS IR Sheet 3");
            end;
        }
    }
    procedure CopyIRCodesToReferenceIRCodes(IRSheetPar: Code[20])
    var
        IRCode: Record "NTS IR Code";
        ReferenceIRCode: Record "NTS Reference IR Code";
    begin
        ReferenceIRCode.SetRange("Source Type", Database::"Prod. Order Routing Line");
        ReferenceIRCode.SetRange("Source Subtype", Rec.Status);
        ReferenceIRCode.SetRange("Source No.", Rec."Routing No.");
        ReferenceIRCode.SetRange("Source Line No.", Rec."Routing Reference No.");
        ReferenceIRCode.SetRange("Source Subline No.", 0);
        ReferenceIRCode.SetRange(Code, IRSheetPar);
        if not ReferenceIRCode.FindSet() then begin
            if IRCode.Get(IRSheetPar) then begin
                ReferenceIRCode.Init();
                ReferenceIRCode."Source Type" := Database::"Prod. Order Routing Line";
                ReferenceIRCode."Source Subtype" := Rec.Status;
                ReferenceIRCode."Source No." := Rec."Routing No.";
                ReferenceIRCode."Source Line No." := Rec."Routing Reference No.";
                ReferenceIRCode."Source Subline No." := 0;
                ReferenceIRCode.Code := IRCode.Code;
                ReferenceIRCode."IR Number" := IRCode."IR Number";
                ReferenceIRCode."IR Sheet Name" := IRCode."IR Sheet Name";
                ReferenceIRCode.Link := IRCode.Link;
                ReferenceIRCode.Insert();
            end;
        end;
    end;
}