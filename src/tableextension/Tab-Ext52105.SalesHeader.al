tableextension 52105 "NTS Sales Header" extends "Sales Header"
{
    fields
    {
        //field(52100; "NTS Requested Delivery Date"; Date) //already used on invoice header.
        field(52101; "NTS Surgeon"; Code[20])
        {
            caption = 'Surgeon';
            DataClassification = ToBeClassified;
            trigger OnLookup()
            var
                HSDMapping: Record "Hosp. Surg. Distrib. Mapping";
                SurgeonRec: Record "NTS Surgeon";
                TempSurgeon: Record "NTS Surgeon" temporary;
            begin
                HSDMapping.SetRange(Hospital, Rec."Sell-to Customer No.");
                if HSDMapping.FindSet() then
                    repeat
                        if SurgeonRec.Get(HSDMapping.Surgeon) then begin
                            TempSurgeon := SurgeonRec;
                            TempSurgeon.Insert();
                        end;
                    until HSDMapping.Next() = 0;

                if Page.RunModal(Page::"NTS Surgeon List", TempSurgeon) = Action::LookupOK then begin
                    Validate(Rec."NTS Surgeon", TempSurgeon.Code);
                end;

            end;


            trigger OnValidate()
            var
                HSDMappingRec: Record "Hosp. Surg. Distrib. Mapping";
            begin
                HSDMappingRec.Reset();
                HSDMappingRec.SetRange(Hospital, Rec."Sell-to Customer No.");
                HSDMappingRec.SetRange(Surgeon, Rec."NTS Surgeon");

                if HSDMappingRec.FindFirst() then
                    Rec."NTS Distributor" := HSDMappingRec.Distributor;
            end;
        }
        field(52102; "NTS Distributor"; Code[50])
        {
            Caption = 'Distributor';
            Editable = false;
            DataClassification = ToBeClassified;
        }
        field(52103; "NTS Reps"; Text[100])
        {
            Caption = 'Reps';
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
                        Rec."NTS Reps" := ContactRec."Name";
                    end;
                end;
            end;

        }
        field(52104; "NTS Sales Type"; Enum "NTS Sales Type")
        {
            Caption = 'Sales Type';
        }
        field(52105; "NTS DoR Number"; code[20])
        {
            Caption = 'DoR Number';
            Editable = false;
            TableRelation = "NTS DOR Header"."No.";
        }
        field(52106; "NTS Set Name"; Code[20])
        {
            Caption = 'Set Name';
            TableRelation = Item."No." WHERE("Assembly BOM" = CONST(true));
        }
        field(52107; "NTS Is TO Created"; Boolean)
        {
            Caption = 'Is TO Created';
            Editable = false;
            DataClassification = CustomerContent;
        }
    }
}
