tableextension 52105 "NTS Sales Header" extends "Sales Header"
{
    fields
    {
        //field(52100; "NTS Requested Delivery Date"; Date) //already used on invoice header.
        field(52101; "NTS Surgeon"; Code[100])
        {
            caption = 'Surgeon';
            DataClassification = ToBeClassified;
            TableRelation = "NTS Surgeon".Code;
            trigger OnValidate()
            var
                SurgeonRec: Record "NTS Surgeon";
            begin
                if Rec."NTS Surgeon" <> '' then begin
                    SurgeonRec.Get(Rec."NTS Surgeon");
                    Validate(Rec."NTS Surgeon Name", SurgeonRec.Name);
                end else
                    Validate(Rec."NTS Surgeon Name", '');
            end;
        }
        field(52102; "NTS Distributor"; Code[20])
        {
            Caption = 'Distributor';
            DataClassification = ToBeClassified;
            TableRelation = Customer."No." where("NTS Distributor" = const(true));
            trigger OnValidate()
            var
                CustomerRec: Record Customer;
            begin
                if "NTS Distributor" <> '' then begin
                    CustomerRec.Get("NTS Distributor");
                    Rec.Validate(Rec."NTS Distributor Name", CustomerRec.Name);
                end else
                    Rec.Validate(Rec."NTS Distributor Name", '');
            end;
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
            //Editable = false;
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
        modify("Document Date")
        {
            Caption = 'Surgery Date';
        }
        modify("External Document No.")
        {
            Caption = 'Customer PO';
        }
        field(52109; "NTS No. of Transfer Orders"; Integer)
        {
            Caption = 'No. of Transfer Orders';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = Count("Transfer Header" where("NTS Sales Order No." = field("No.")));
        }
        field(52110; "NTS No. of Posted Trans. Shpt."; Integer)
        {
            Caption = 'No. of Posted Transfer Shipments';
            FieldClass = FlowField;
            CalcFormula = Count("Transfer Shipment Header" where("NTS Sales Order No." = field("No.")));
            Editable = false;
        }
        field(52111; "NTS Surgeon Name"; Text[100])
        {
            Caption = 'Surgeon Name';
            Editable = false;
            TableRelation = "NTS Surgeon".Name where(Code = field("NTS Surgeon"));
            ValidateTableRelation = false;
        }
        field(52112; "NTS Distributor Name"; Text[100])
        {
            Caption = 'Distributor Name';
            Editable = false;
            TableRelation = Customer.Name where("No." = field("NTS Distributor"));
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
