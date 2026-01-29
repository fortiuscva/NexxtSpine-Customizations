tableextension 52112 "NTS Prod. Order Routing Line" extends "Prod. Order Routing Line"
{
    fields
    {
        field(52100; "NTS IR Sheet 1"; Code[20])
        {
            Caption = 'IR Sheet 1';
            DataClassification = ToBeClassified;
            TableRelation = "NTS IR Code".Code;
            trigger OnValidate()
            begin
                if SingleInstanceCU.GetFromProdRoutingPage() then
                    CopyIRCodesToReferenceIRCodes("NTS IR Sheet 1", false);
            end;
        }
        field(52101; "NTS IR Sheet 2"; Code[20])
        {
            Caption = 'IR Sheet 2';
            DataClassification = ToBeClassified;
            TableRelation = "NTS IR Code".Code;

            trigger OnValidate()
            begin
                if SingleInstanceCU.GetFromProdRoutingPage() then
                    CopyIRCodesToReferenceIRCodes("NTS IR Sheet 2", false);
            end;
        }
        field(52102; "NTS IR Sheet 3"; Code[20])
        {
            Caption = 'IR Sheet 3';
            DataClassification = ToBeClassified;
            TableRelation = "NTS IR Code".Code;

            trigger OnValidate()
            begin
                if SingleInstanceCU.GetFromProdRoutingPage() then
                    CopyIRCodesToReferenceIRCodes("NTS IR Sheet 3", false);
            end;
        }
    }

    var
        SingleInstanceCU: Codeunit "NTS Single Instance";

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

    procedure CopyIRCodesToReferenceIRCodes(IRSheetPar: Code[20]; IsManualEntry: Boolean)
    var
        IRCode: Record "NTS IR Code";
        ReferenceIRCode: Record "NTS Reference IR Code";
        ManualIRLog: Record "NTS Manual IR Sheet Log";
        OneDriveIntegrationCULcl: Codeunit "NTS OneDrive Integration";
        NewFileName: Text;
    begin
        IRCode.Get(IRSheetPar);
        if IRCode."IR/IP Type" = IRCode."IR/IP Type"::" " then
            Error('IR/IP Type is blank in IR Code.');

        if IsManualEntry then begin
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

        ReferenceIRCode.Reset();
        ReferenceIRCode.SetRange("Source Type", Database::"Prod. Order Routing Line");
        ReferenceIRCode.SetRange("Source Subtype", Rec.Status);
        //ReferenceIRCode.SetRange("Source No.", Rec."Routing No.");
        ReferenceIRCode.SetRange("Source No.", Rec."Prod. Order No.");
        ReferenceIRCode.SetRange("Source Line No.", Rec."Routing Reference No.");
        ReferenceIRCode.SetRange("Source Subline No.", 0);
        // ReferenceIRCode.SetRange(Code, IRSheetPar);

        if IRCode."IR/IP Type" = IRCode."IR/IP Type"::IP then
            ReferenceIRCode.SetRange("Operation No.", Rec."Operation No.");

        ReferenceIRCode.SetRange("IR Number", IRCode."IR Number");
        if not ReferenceIRCode.FindSet() then begin
            //if IRCode.Get(IRSheetPar) then begin
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
            ReferenceIRCode."Template Link" := IRCode.Link;
            ReferenceIRCode."IR Sheet Name" := Rec."Prod. Order No." + IRCode."IR Number" + IRCode."IR Sheet Name";

            if IsManualEntry then
                NewFileName := 'Manual_' + Rec."Prod. Order No." + '-' +
                               Format(Rec."Routing Reference No.") + '-' +
                               IRCode."IR Number"
            else
                NewFileName := Rec."Prod. Order No." + '-' +
                               Format(Rec."Routing Reference No.") + '-' +
                               IRCode."IR Number";

            OneDriveIntegrationCULcl.ConnectOneDriveFile(NewFileName, IRCode."File Name", ReferenceIRCode."Sharepoint Link");
            //ReferenceIRCode."Mobile Link" := 'ms-excel:ofe|u|' + ReferenceIRCode.Link;
            // NewFileName := Rec."Prod. Order No." + '-' + format(Rec."Routing Reference No.") + '-' + IRCode."IR Number";
            //ReferenceIRCode."Mobile Link" := 'https://convert.nexxtspine.com:3000' + '/' + NewFileName + '.xlsm' + '&file=' + NewFileName + '.xlsm';
            ReferenceIRCode."Mobile Link" := ReplaceFirst(ReferenceIRCode."Sharepoint Link", 'https://nexxtspinellc-my.sharepoint.com', 'https://convert.nexxtspine.com:3000');

            ReferenceIRCode."IR/IP Type" := IRCode."IR/IP Type";

            ReferenceIRCode.Insert();

            //TransferReferenceIRCodeLinkToProdOrderLinks(ReferenceIRCode.Link, Rec, IRCode, '');
            if ReferenceIRCode."Mobile Link" <> '' then
                if ReferenceIRCode."IR/IP Type" = ReferenceIRCode."IR/IP Type"::IR then
                    TransferReferenceIRCodeLinkToProdOrderLinks(ReferenceIRCode."Mobile Link", Rec, IRCode, ReferenceIRCode."Source No." + ',' + ReferenceIRCode."IR Number")
                else
                    TransferReferenceIRCodeLinkToProdOrderLinks(ReferenceIRCode."Mobile Link", Rec, IRCode, ReferenceIRCode."Source No." + ',' + ReferenceIRCode."Operation No." + ',' + ReferenceIRCode."IR Number");
            //end;
        end;
    end;

    local procedure TransferReferenceIRCodeLinkToProdOrderLinks(LinkPar: Text[2048]; ProdOrderRoutingLinePar: Record "Prod. Order Routing Line"; IRCodePar: Record "NTS IR Code"; MobileURLDesc: text[100])
    var
        NewRecLink: Record "Record Link";
        EntryNo: Integer;
        ProductionOrder: Record "Production Order";
    begin
        if ProductionOrder.Get(Rec.Status, Rec."Prod. Order No.") then begin
            // NewRecLink.Reset();
            // NewRecLink.SetRange("Record ID", ProductionOrder.RecordId);
            // if NewRecLink.FindSet() then
            //     NewRecLink.DeleteAll();

            NewRecLink.Reset();
            if NewRecLink.FindLast() then
                EntryNo := NewRecLink."Link ID" + 1
            else
                EntryNo := 1;

            NewRecLink.INIT;
            NewRecLink."Link ID" := EntryNo;
            NewRecLink."Record ID" := ProductionOrder.RECORDID;
            NewRecLink.URL1 := LinkPar;
            //NewRecLink.Description := MobileURLDesc + Format(ProdOrderRoutingLinePar.RecordId) + IRCodePar."IR Number";
            NewRecLink.Description := MobileURLDesc;
            NewRecLink.Type := NewRecLink.Type::Link;
            NewRecLink."User ID" := UserId;
            NewRecLink.Created := CreateDateTime(Today, Time);
            NewRecLink.Company := CompanyName;
            NewRecLink.INSERT;
        end;
    end;

    procedure ReplaceFirst(SourceText: Text; OldValue: Text; NewValue: Text): Text
    var
        Pos: Integer;
        BeforeText: Text;
        AfterText: Text;
    begin
        Pos := StrPos(SourceText, OldValue);
        if Pos > 0 then begin
            BeforeText := CopyStr(SourceText, 1, Pos - 1);
            AfterText := CopyStr(SourceText, Pos + StrLen(OldValue), StrLen(SourceText) - (Pos + StrLen(OldValue)) + 1);
            exit(BeforeText + NewValue + AfterText);
        end else
            exit(SourceText);
    end;
}