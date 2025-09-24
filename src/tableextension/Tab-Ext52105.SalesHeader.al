tableextension 52105 "NTS Sales Header" extends "Sales Header"
{
    fields
    {
        //field(52100; "NTS Requested Delivery Date"; Date) //already used on invoice header.
        field(52101; "NTS Surgeon"; Code[20])
        {
            caption = 'Surgeon';
            DataClassification = ToBeClassified;
            TableRelation = "Hosp. Surg. Distrib. Mapping".Surgeon where(Hospital = field("Sell-to Customer No."));
            trigger OnValidate()
            var
                HSDMappingRec: Record "Hosp. Surg. Distrib. Mapping";
            begin
                HSDMappingRec.Reset();
                HSDMappingRec.SetRange(Hospital, Rec."Sell-to Customer No.");
                HSDMappingRec.SetRange(Surgeon, Rec."NTS Surgeon");
                if HSDMappingRec.FindFirst() then
                    Rec."NTS Distributor" := HSDMappingRec.Distributor
                else
                    Rec."NTS Distributor" := '';
            end;
        }
        field(52102; "NTS Distributor"; Code[20])
        {
            Caption = 'Distributor';
            Editable = false;
            DataClassification = ToBeClassified;
            TableRelation = Customer."No." where("NTS Distributor" = const(true));
        }
        field(52103; "NTS Reps."; Code[20])
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
                ContactBusinessRel.SetRange("No.", Rec."NTS Distributor");
                if ContactBusinessRel.FindSet() then begin
                    ContactRec.Reset();
                    ContactRec.SetRange("Company No.", ContactBusinessRel."Contact No.");
                    ContactListPage.SetTableView(ContactRec);
                    if PAGE.RUNMODAL(PAGE::"Contact List", ContactRec) = ACTION::LookupOK then begin
                        Rec."NTS Reps." := ContactRec."No.";
                    end;
                end;
                ValidateReps();
            end;

            trigger OnValidate()
            begin
                ValidateReps();
            end;
        }
        field(52104; "NTS Sales Type"; Enum "NTS Sales Type")
        {
            Caption = 'Sales Type';
        }
        field(52105; "NTS DOR No."; code[20])
        {
            Caption = 'DOR No.';
            Editable = false;
            TableRelation = "NTS DOR Header"."No.";
        }
        field(52106; "NTS Set Name"; Code[20])
        {
            Caption = 'Set Name';
            TableRelation = Item."No." WHERE("Assembly BOM" = CONST(true));
        }
        field(52107; "NTS Transfer Order Created"; Boolean)
        {
            Caption = 'Transfer Order Created';
            Editable = false;
            DataClassification = CustomerContent;
        }

        field(52108; "NTS Reps. Name"; Text[100])
        {
            Caption = 'Reps. Name';
            DataClassification = CustomerContent;
            Editable = false;
            TableRelation = Contact.Name where("No." = field("NTS Reps."));
            ValidateTableRelation = false;
        }
    }

    Var
        ContactRec: Record Contact;


    procedure ValidateReps()
    begin
        if "NTS Reps." <> '' then begin
            ContactRec.Get("NTS Reps.");
            "NTS Reps. Name" := ContactRec.Name;
        end else
            "NTS Reps. Name" := '';
    end;
}
