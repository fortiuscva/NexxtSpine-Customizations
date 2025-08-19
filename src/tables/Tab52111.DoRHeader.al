table 52111 "NTS DoR Header"
{
    Caption = 'DoR Header';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "DoR Number"; Code[20])
        {
            Caption = 'DoR Number';
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
        field(5; "Serial Number"; Code[20])
        {
            Caption = 'Serial Number';
        }
        field(6; Status; Enum "NTS Status")
        {
            Caption = 'Status';
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
    }
    keys
    {
        key(PK; "DoR Number")
        {
            Clustered = true;
        }
    }
}
