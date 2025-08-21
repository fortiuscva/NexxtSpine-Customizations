tableextension 52105 "NTS Sales Header" extends "Sales Header"
{
    fields
    {
        //field(52100; "NTS Requested Delivery Date"; Date) //already used on invoice header.
        field(52101; "NTS Surgeon"; Text[100])
        {
            caption = 'Surgeon';
            DataClassification = ToBeClassified;
            TableRelation = "Hosp. Surg. Distrib. Mapping".Surgeon where(Hospital = field("Sell-to Customer No."));
            trigger OnValidate()
            var
                HSDMappingRec: Record "Hosp. Surg. Distrib. Mapping";
            begin
                if Rec."Sell-to Customer No." <> '' then
                    if HSDMappingRec.Get(Rec."Sell-to Customer No.", Rec."NTS Surgeon") then
                        Rec."NTS Distributor" := HSDMappingRec.Distributor;
            end;
        }
        field(52102; "NTS Distributor"; Code[50])
        {
            Caption = 'Distributor';
            DataClassification = ToBeClassified;
        }
        field(52103; "NTS Reps"; Text[100])
        {
            Caption = 'Reps';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup(Customer.Contact where("No." = field("NTS Distributor")));
        }
    }
}
