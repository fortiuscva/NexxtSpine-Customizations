table 52111 "NTS DOR Header"
{
    Caption = 'DOR Header';
    DataCaptionFields = "No.";
    DataClassification = CustomerContent;
    LookupPageId = "NTS Delivery of Records";
    DrillDownPageId = "NTS Delivery of Records";

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
        field(2; "Customer No."; Code[20])
        {
            Caption = 'Customer';
            TableRelation = Customer."No." WHERE("NTS Distributor" = CONST(false));
            trigger OnValidate()
            begin
                TestStatusOpen();
                if (Rec."Customer No." <> xRec."Customer No.") then begin
                    if (Rec."Customer No." <> '') then begin
                        CustomerRec.get("Customer No.");
                        "Customer Name" := CustomerRec.Name;
                        // Validate(Surgeon, '');
                        // Validate("Reps.", '');
                    end else begin
                        "Customer Name" := '';
                        // Validate(Surgeon, '');
                        // Validate("Reps.", '');
                    end;
                end;
            end;
        }
        field(3; "Surgery Date"; Date)
        {
            Caption = 'Surgery Date';
            trigger OnValidate()
            begin
                TestStatusOpen();
            end;
        }
        field(4; "Set Name"; Code[20])
        {
            Caption = 'Set Name';
            TableRelation = Item."No." WHERE("Assembly BOM" = CONST(true));
            trigger OnValidate()
            begin
                TestStatusOpen();
                ValidateSetName();
            end;
        }
        field(5; "Serial No."; Code[50])
        {
            Caption = 'Serial No.';
            TableRelation = "Serial No. Information"."Serial No." where("Item No." = field("Set Name"));
            trigger OnValidate()
            var
                NTSFunctions: Codeunit "NTS NexxtSpine Functions";

            begin
                TestStatusOpen();
                if Rec."Serial No." <> '' then
                    NTSFunctions.GetAndValidateLOTSerialCombo(Rec."Set Name", Rec."Lot No.", Rec."Serial No.");
            end;
        }
        field(6; Status; Enum "NTS DOR Status")
        {
            Caption = 'Status';
            Editable = false;
        }
        field(7; Surgeon; Code[20])
        {
            Caption = 'Surgeon';
            TableRelation = "NTS Surgeon".Code;
            trigger OnValidate()
            begin
                // ValidateSurgeon();
            end;
        }
        field(8; Distributor; Code[20])
        {
            Caption = 'Distributor';
            TableRelation = Customer."No." WHERE("NTS Distributor" = CONST(true));

            trigger OnValidate()
            var
                Customer: Record Customer;
            begin
                TestStatusOpen();
                if (Rec.Distributor <> xRec.Distributor) then begin
                    if Distributor <> '' then begin
                        Customer.Get(Distributor);
                        if Customer."Location Code" <> '' then
                            Rec.Validate("Location Code", Customer."Location Code")
                        else
                            Rec.Validate("Location Code", '');
                        Rec.Validate("Reps.", '');
                    end else begin
                        Rec.Validate("Location Code", '');
                        Rec.Validate("Reps.", '');
                    end;
                end;
            end;
        }
        field(9; "Reps."; Code[20])
        {
            Caption = 'Reps.';
            TableRelation = Contact."No.";
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
                        Validate(Rec."Reps.", ContactRec."No.");
                        Validate(Rec."Reps. Name", ContactRec.Name);
                    end;
                end;
            end;

            trigger OnValidate()
            begin
                TestStatusOpen();
                ValidateReps();
            end;
        }
        field(10; "Lot No."; Code[50])
        {
            Caption = 'Lot No.';
            TableRelation = "Lot No. Information"."Lot No." where("Item No." = field("Set Name"));
            trigger OnValidate()
            var
                NTSFunctions: Codeunit "NTS NexxtSpine Functions";
            begin
                TestStatusOpen();
                if ("Lot No." <> '') then
                    NTSFunctions.GetAndValidateLOTSerialCombo(Rec."Set Name", Rec."Lot No.", Rec."Serial No.");
            end;
        }
        field(11; Posted; Boolean)
        {
            Caption = 'Posted';
            Editable = false;
        }
        field(20; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
            trigger OnValidate()
            begin
                TestStatusOpen();
            end;
        }
        field(21; Quantity; Integer)
        {
            Caption = 'Quantity';
            Editable = false;
            trigger OnValidate()
            begin
                TestStatusOpen();
            end;
        }
        field(22; "Location Code"; code[20])
        {
            Caption = 'Location Code';
        }

        field(107; "No. Series"; Code[20])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
            trigger OnValidate()
            begin
                TestStatusOpen();
            end;
        }
        field(79; "Customer Name"; Text[100])
        {
            Caption = 'Customer Name';
            TableRelation = Customer.Name;
            ValidateTableRelation = false;
            Editable = false;
        }

        field(85; "Set Description"; Text[100])
        {
            Caption = 'Set Description';
            TableRelation = Item.Description;
            ValidateTableRelation = false;
            Editable = false;
        }
        field(90; "Reps. Name"; Text[100])
        {
            Caption = 'Reps. Name';
            Editable = false;
            TableRelation = Contact.Name where("No." = field("Reps."));
            ValidateTableRelation = false;
        }
    }
    keys
    {
        key(PK; "No.")
        {
            Clustered = true;
        }
        key(Key2; "Customer No.", "Location Code") { Clustered = false; }
    }
    fieldgroups
    {
        fieldgroup(DropDown; "No.", "Customer Name", "Set Description", Surgeon, "Reps.", Distributor)
        {
        }
        fieldgroup(Brick; "No.", "Customer Name", "Set Description", Surgeon, "Reps.", Distributor)
        {
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

    trigger OnDelete()
    begin
        DORLineRec.Reset();
        DORLineRec.SetRange("Document No.", "No.");
        DORLineRec.DeleteAll(true);
    end;

    Var

        SalesSetup: Record "Sales & Receivables Setup";
        ContactBusinessRel: Record "Contact Business Relation";
        ContactRec: Record Contact;
        SelectNoSeriesAllowed: Boolean;
        InsertMode: Boolean;
        DORHeader: Record "NTS DOR Header";
        CustomerRec: Record Customer;
        ItemRec: Record Item;
        Text051: Label 'The DOR %1 already exists.';
        DORLineRec: Record "NTS DOR Line";

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

    procedure TestStatusOpen()
    begin
        TestField(Status, Status::Open);
    end;


    procedure ValidateSetName()
    begin
        if (Rec."Set Name" <> xRec."Set Name") then begin
            if (Rec."Set Name" <> '') then begin
                ItemRec.get("Set Name");
                "Set Description" := ItemRec.Description;
                Validate("Lot No.", '');
                Validate("Serial No.");
                Validate(Quantity, 1);
            end else begin
                "Set Description" := '';
                Validate("Lot No.", '');
                Validate("Serial No.");
                Validate(Quantity, 0);
            end;
        end;
    end;

    // procedure ValidateSurgeon()
    // var
    //     HSDMappingRec: Record "Hosp. Surg. Distrib. Mapping";
    // begin
    //     if (xRec.Surgeon <> Rec.Surgeon) then begin
    //         if Surgeon <> '' then begin
    //             HSDMappingRec.Reset();
    //             HSDMappingRec.SetRange(Hospital, Rec."Customer No.");
    //             HSDMappingRec.SetRange(Surgeon, Rec.Surgeon);
    //             HSDMappingRec.FindFirst();
    //             Rec.Validate(Distributor, HSDMappingRec.Distributor);
    //             Rec.Validate("Reps.", '');
    //         end else begin
    //             Rec.Validate(Distributor, '');
    //             Rec.Validate("Reps.", '');
    //         end;
    //     end;
    // end;

    procedure ValidateReps()
    begin
        if "Reps." <> '' then begin
            TestField(Distributor);
            ContactBusinessRel.SetRange("Link to Table", ContactBusinessRel."Link to Table"::Customer);
            ContactBusinessRel.SetRange("No.", Rec.Distributor);
            if ContactBusinessRel.FindSet() then begin
                ContactRec.Reset();
                ContactRec.SetRange("Company No.", ContactBusinessRel."Contact No.");
                ContactRec.SetRange("No.", "Reps.");
                ContactRec.FindFirst();
                Validate(Rec."Reps. Name", ContactRec.Name);
            end;
        end else
            Validate(Rec."Reps. Name", '');

    end;
}
