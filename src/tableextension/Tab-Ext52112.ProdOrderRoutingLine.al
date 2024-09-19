tableextension 52112 "NTS Prod. Order Routing Line" extends "Prod. Order Routing Line"
{
    fields
    {
        field(52100; "NTS IR Sheet 1"; Code[20])
        {
            Caption = 'IR Sheet 1';
            DataClassification = ToBeClassified;
            TableRelation = "NTS Reference IR Code".Code where("Source No." = field("Prod. Order No."));

            trigger OnValidate()
            begin
                CopyIRCodesToReferenceIRCodes("NTS IR Sheet 1");
            end;
        }
        field(52101; "NTS IR Sheet 2"; Code[20])
        {
            Caption = 'IR Sheet 2';
            DataClassification = ToBeClassified;
            TableRelation = "NTS Reference IR Code".Code where("Source No." = field("Prod. Order No."));

            trigger OnValidate()
            begin
                CopyIRCodesToReferenceIRCodes("NTS IR Sheet 2");
            end;
        }
        field(52102; "NTS IR Sheet 3"; Code[20])
        {
            Caption = 'IR Sheet 3';
            DataClassification = ToBeClassified;
            TableRelation = "NTS Reference IR Code".Code where("Source No." = field("Prod. Order No."));

            trigger OnValidate()
            begin
                CopyIRCodesToReferenceIRCodes("NTS IR Sheet 3");
            end;
        }
    }
    trigger OnAfterDelete()
    var
        ReferenceIRCode: Record "NTS Reference IR Code";
    begin
        ReferenceIRCode.Reset();
        ReferenceIRCode.SetRange("Source Type", Database::"Prod. Order Routing Line");
        ReferenceIRCode.SetRange("Source Subtype", Rec.Status);
        //ReferenceIRCode.SetRange("Source No.", Rec."Routing No.");
        ReferenceIRCode.SetRange("Source No.", Rec."Prod. Order No.");
        ReferenceIRCode.SetRange("Source Line No.", Rec."Routing Reference No.");
        ReferenceIRCode.SetRange("Source Subline No.", 0);
        ReferenceIRCode.SetRange("Operation No.", Rec."Operation No.");
        if ReferenceIRCode.FindFirst() then
            ReferenceIRCode.Delete();
    end;

    procedure CopyIRCodesToReferenceIRCodes(IRSheetPar: Code[20])
    var
        IRCode: Record "NTS IR Code";
        ReferenceIRCode: Record "NTS Reference IR Code";
        OneDriveIntegrationCULcl: Codeunit "NTS OneDrive Integration";
    begin
        ReferenceIRCode.Reset();
        ReferenceIRCode.SetRange("Source Type", Database::"Prod. Order Routing Line");
        ReferenceIRCode.SetRange("Source Subtype", Rec.Status);
        //ReferenceIRCode.SetRange("Source No.", Rec."Routing No.");
        ReferenceIRCode.SetRange("Source No.", Rec."Prod. Order No.");
        ReferenceIRCode.SetRange("Source Line No.", Rec."Routing Reference No.");
        ReferenceIRCode.SetRange("Source Subline No.", 0);
        ReferenceIRCode.SetRange(Code, IRSheetPar);
        ReferenceIRCode.SetRange("Operation No.", Rec."Operation No.");
        if not ReferenceIRCode.FindSet() then begin
            if IRCode.Get(IRSheetPar) then begin
                ReferenceIRCode.Init();
                ReferenceIRCode."Source Type" := Database::"Prod. Order Routing Line";
                ReferenceIRCode."Source Subtype" := Rec.Status;
                //ReferenceIRCode."Source No." := Rec."Routing No.";
                ReferenceIRCode."Source No." := Rec."Prod. Order No.";
                ReferenceIRCode."Source Line No." := Rec."Routing Reference No.";
                ReferenceIRCode."Source Subline No." := 0;
                ReferenceIRCode.Code := IRCode.Code;
                ReferenceIRCode."IR Number" := IRCode."IR Number";
                ReferenceIRCode."Operation No." := Rec."Operation No.";
                //ReferenceIRCode."IR Sheet Name" := IRCode."IR Sheet Name";
                //ReferenceIRCode.Link := IRCode.Link;
                ReferenceIRCode."IR Sheet Name" := Rec."Prod. Order No." + IRCode."IR Number" + IRCode."IR Sheet Name";
                OneDriveIntegrationCULcl.ConnectOneDriveFile(Rec."Prod. Order No." + IRCode."IR Number" + IRCode."IR Sheet Name", IRCode."IR Number", ReferenceIRCode.Link);
                ReferenceIRCode.Insert();

                TransferReferenceIRCodeLinkToProdOrderLinks(ReferenceIRCode, Rec, IRCode);
            end;
        end;
    end;

    local procedure TransferReferenceIRCodeLinkToProdOrderLinks(ReferenceIRCodePar: Record "NTS Reference IR Code"; ProdOrderRoutingLinePar: Record "Prod. Order Routing Line"; IRCodePar: Record "NTS IR Code")
    var
        NewRecLink: Record "Record Link";
        EntryNo: Integer;
        ProductionOrder: Record "Production Order";
    begin
        if ProductionOrder.Get(Rec.Status, Rec."Prod. Order No.") then begin
            NewRecLink.Reset();
            if NewRecLink.FindLast() then
                EntryNo := NewRecLink."Link ID" + 1
            else
                EntryNo := 1;

            NewRecLink.INIT;
            NewRecLink."Link ID" := EntryNo;
            NewRecLink."Record ID" := ProductionOrder.RECORDID;
            NewRecLink.URL1 := ReferenceIRCodePar.Link;
            NewRecLink.Description := Format(ProdOrderRoutingLinePar.RecordId) + IRCodePar."IR Number";
            NewRecLink.Type := NewRecLink.Type::Link;
            NewRecLink."User ID" := UserId;
            NewRecLink.Created := CreateDateTime(Today, Time);
            NewRecLink.Company := CompanyName;
            NewRecLink.INSERT;
        end;
    end;
}