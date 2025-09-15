table 52111 "NTS DOR Header"
{
    Caption = 'DOR Header';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
            trigger OnValidate()
            var
                NoSeries: Codeunit "No. Series";
            begin
                if "No." <> xRec."No." then begin
                    GetSalesSetup();
                    NoSeries.TestManual(GetNoSeriesCode());
                    "No. Series" := '';
                end;
            end;
        }
        field(2; Customer; Code[20])
        {
            Caption = 'Customer';
            TableRelation = Customer."No." WHERE("NTS Is Distributor" = CONST(false));
        }
        field(3; "Surgery Date"; Date)
        {
            Caption = 'Surgery Date';
        }
        field(4; "Set Name"; Code[20])
        {
            Caption = 'Set Name';
            TableRelation = Item."No." WHERE("Assembly BOM" = CONST(true));
        }
        field(5; "Serial No."; Code[20])
        {
            Caption = 'Serial No.';
            TableRelation = "Serial No. Information"."Serial No." where("Item No." = field("Set Name"));
        }
        field(6; Status; Enum "NTS DOR Status")
        {
            Caption = 'Status';
            Editable = false;
        }
        field(7; Surgeon; Text[100])
        {
            Caption = 'Surgeon';
            trigger OnLookup()
            var
                HSDMapping: Record "Hosp. Surg. Distrib. Mapping";
                SurgeonRec: Record "NTS Surgeon";
                TempSurgeon: Record "NTS Surgeon" temporary;
            begin

                HSDMapping.SetRange(Hospital, Rec.Customer);
                if HSDMapping.FindSet() then
                    repeat
                        if SurgeonRec.Get(HSDMapping.Surgeon) then begin
                            TempSurgeon := SurgeonRec;
                            TempSurgeon.Insert(true);
                        end;
                    until HSDMapping.Next() = 0;

                if Page.RunModal(Page::"NTS Surgeon List", TempSurgeon) = Action::LookupOK then begin
                    Validate(Rec.Surgeon, TempSurgeon."Surgeon Name");
                end;

            end;


            trigger OnValidate()
            var
                HSDMappingRec: Record "Hosp. Surg. Distrib. Mapping";
            begin
                HSDMappingRec.Reset();
                HSDMappingRec.SetRange(Hospital, Rec.Customer);
                HSDMappingRec.SetRange(Surgeon, Rec.Surgeon);

                if HSDMappingRec.FindFirst() then
                    Rec.Distributor := HSDMappingRec.Distributor;
            end;
        }
        field(8; Distributor; Code[50])
        {
            Caption = 'Distributor';
            Editable = false;
        }
        field(9; Reps; Text[100])
        {
            Caption = 'Reps';
            trigger OnLookup()
            var
                ContactBusinessRel: Record "Contact Business Relation";
                ContactRec: Record Contact;
                ContactListPage: Page "Contact List";
            begin

                ContactBusinessRel.SetRange("Link to Table", ContactBusinessRel."Link to Table"::Customer);
                ContactBusinessRel.SetRange("No.", Rec.Distributor);

                if ContactBusinessRel.FindSet() then begin
                    ContactRec.Reset();
                    ContactRec.SetRange("Company No.", ContactBusinessRel."Contact No.");

                    ContactListPage.SetTableView(ContactRec);
                    if PAGE.RUNMODAL(PAGE::"Contact List", ContactRec) = ACTION::LookupOK then begin
                        Rec.Reps := ContactRec."Name";
                    end;
                end;
            end;
        }
        field(10; "Lot No."; Code[50])
        {
            Caption = 'Lot No.';
            TableRelation = "Lot No. Information"."Lot No." where("Item No." = field("Set Name"));
        }
        field(11; Posted; Boolean)
        {
            Caption = 'Posted';
        }
        field(20; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
        }
        field(21; Quantity; Decimal)
        {
            Caption = 'Quantity';
        }

        field(107; "No. Series"; Code[20])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
        }

    }
    keys
    {
        key(PK; "No.")
        {
            Clustered = true;
        }
    }

    trigger OnInsert()
    var
        IsHandled: Boolean;
    begin

        InitInsert();
        InsertMode := true;

        // Remove view filters so that the cards does not show filtered view notification
        SetView('');
    end;

    procedure InitInsert()
    var
        DORHeader2: Record "NTS DOR Header";
        NoSeries: Codeunit "No. Series";
        NoSeriesMgt2: Codeunit NoSeriesManagement;
        NoSeriesCode: Code[20];
        IsHandled: Boolean;
    begin
        if "No." = '' then begin
            TestNoSeries();
            NoSeriesCode := GetNoSeriesCode();
            NoSeriesMgt2.RaiseObsoleteOnBeforeInitSeries(NoSeriesCode, xRec."No. Series", "Posting Date", "No.", "No. Series", IsHandled);
            if not IsHandled then begin
                "No. Series" := NoSeriesCode;
                if NoSeries.AreRelated("No. Series", xRec."No. Series") then
                    "No. Series" := xRec."No. Series";
                "No." := NoSeries.GetNextNo("No. Series", "Posting Date");
                DORHeader2.ReadIsolation(IsolationLevel::ReadUncommitted);
                DORHeader2.SetLoadFields("No.");
                while DORHeader2.Get("No.") do
                    "No." := NoSeries.GetNextNo("No. Series", "Posting Date");
                NoSeriesMgt2.RaiseObsoleteOnAfterInitSeries("No. Series", NoSeriesCode, "Posting Date", "No.");
            end;
        end;
        InitRecord();
    end;

    procedure InitRecord()
    var
        ShipToAddress: Record "Ship-to Address";
        ArchiveManagement: Codeunit ArchiveManagement;
        LocationCode: Code[10];
        IsHandled: Boolean;
        NewOrderDate: Date;
    begin
        GetSalesSetup();
        IsHandled := false;

        InitPostingDate();

        NewOrderDate := WorkDate();
    end;

    procedure TestNoSeries()
    var
        IsHandled: Boolean;
    begin
        GetSalesSetup();
        SalesSetup.TestField("NTS DOR Nos.");
    end;

    procedure GetNoSeriesCode(): Code[20]
    var
        NoSeries: Codeunit "No. Series";
        NoSeriesCode: Code[20];
        IsHandled: Boolean;
    begin
        GetSalesSetup();
        NoSeriesCode := SalesSetup."NTS DOR Nos.";

        if not SelectNoSeriesAllowed then
            exit(NoSeriesCode);

        if NoSeries.IsAutomatic(NoSeriesCode) then
            exit(NoSeriesCode);

        if NoSeries.HasRelatedSeries(NoSeriesCode) then
            if NoSeries.LookupRelatedNoSeries(NoSeriesCode, "No. Series") then
                exit("No. Series");

        exit(NoSeriesCode);
    end;

    local procedure GetSalesSetup()
    begin
        SalesSetup.Get();
    end;

    procedure SetAllowSelectNoSeries()
    begin
        SelectNoSeriesAllowed := true;
    end;

    local procedure InitPostingDate()
    var
        IsHandled: Boolean;
    begin
        "Posting Date" := WorkDate();
    end;

    procedure ConfirmDeletion() Result: Boolean
    var
    begin
        exit(true);
    end;

    procedure AssistEdit(OlDORHeader: Record "NTS DOR Header") Result: Boolean
    var
        DORHeader2: Record "NTS DOR Header";
        NoSeries: Codeunit "No. Series";
        IsHandled: Boolean;
    begin
        DORHeader.Copy(Rec);
        GetSalesSetup();
        DORHeader.TestNoSeries();
        if NoSeries.LookupRelatedNoSeries(DORHeader.GetNoSeriesCode(), OlDORHeader."No. Series", DORHeader."No. Series") then begin
            DORHeader."No." := NoSeries.GetNextNo(DORHeader."No. Series");
            if DORHeader2.Get(DORHeader."No.") then
                Error(Text051, LowerCase(DORHeader."No."));
            Rec := DORHeader;
            exit(true);
        end;
    end;

    procedure PerformManualReopen(var DorHeader: Record "NTS DOR Header")
    var
        BatchProcessingMgt: Codeunit "Batch Processing Mgt.";
        NoOfSelected: Integer;
        NoOfSkipped: Integer;
    begin
        NoOfSelected := DorHeader.Count;

        // Exclude already Open docs
        DorHeader.SetFilter(Status, '<>%1', DorHeader.Status::Open);

        NoOfSkipped := NoOfSelected - DorHeader.Count;

        BatchProcessingMgt.BatchProcess(
            DorHeader,
            Codeunit::"NTS DOR Manual Reopen",
            Enum::"Error Handling Options"::"Show Error",
            NoOfSelected,
            NoOfSkipped);
    end;

    procedure PerformManualRelease()
    var
        DORRelaeseMgmnt: Codeunit "NTS DOR Release Management";
        IsHandled: Boolean;
    begin
        if Rec.Status <> Rec.Status::Released then begin
            DORRelaeseMgmnt.PerformManualRelease(Rec);
            Commit();
        end;
    end;

    procedure PerformManualRelease(var DorHeader: Record "NTS DOR Header")
    var
        BatchProcessingMgt: Codeunit "Batch Processing Mgt.";
        NoOfSelected: Integer;
        NoOfSkipped: Integer;
        PrevFilterGroup: Integer;
    begin
        NoOfSelected := DorHeader.Count;

        PrevFilterGroup := DorHeader.FilterGroup();
        DorHeader.FilterGroup(10); // apply filter in a safe group
        DorHeader.SetFilter(Status, '<>%1', DorHeader.Status::Released);

        NoOfSkipped := NoOfSelected - DorHeader.Count;

        BatchProcessingMgt.BatchProcess(
            DorHeader,
            Codeunit::"NTS DOR Manual Release",
            Enum::"Error Handling Options"::"Show Error",
            NoOfSelected,
            NoOfSkipped);

        // clear filters
        DorHeader.SetRange(Status);
        DorHeader.FilterGroup(PrevFilterGroup);
    end;

    Var

        SalesSetup: Record "Sales & Receivables Setup";
        SelectNoSeriesAllowed: Boolean;
        InsertMode: Boolean;
        DORHeader: Record "NTS DOR Header";
        Text051: Label 'The DOR %1 already exists.';

}
