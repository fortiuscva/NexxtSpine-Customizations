table 52110 "Hosp. Surg. Distrib. Mapping"
{
    Caption = 'Hospital-Surgeon-Distributor Mapping';
    DataClassification = ToBeClassified;
    LookupPageId = "NTS Hsp. Surg. Dist. Mappings";
    DrillDownPageId = "NTS Hsp. Surg. Dist. Mappings";

    fields
    {
        field(1; Hospital; Code[20])
        {
            Caption = 'Hospital';
            TableRelation = Customer."No." where("NTS Distributor" = const(false));
            NotBlank = true;
            ValidateTableRelation = false;

            trigger OnValidate()
            begin
                if Hospital <> '' then begin
                    CustomerRec.reset;
                    CustomerRec.SetRange("No.", Hospital);
                    CustomerRec.SetRange("NTS Distributor", false);
                    CustomerRec.FindFirst();
                end;
            end;
        }
        field(2; Surgeon; Code[20])
        {
            Caption = 'Surgeon';
            TableRelation = "NTS Surgeon".Code;
            NotBlank = true;
            ValidateTableRelation = false;

            trigger OnValidate()
            begin
                if Surgeon <> '' then
                    SurgeonRec.get(Surgeon);
            end;
        }
        field(3; Distributor; Code[20])
        {
            Caption = 'Distributor';
            TableRelation = Customer where("NTS Distributor" = const(true));
            NotBlank = true;
            ValidateTableRelation = false;

            trigger OnValidate()
            var
                HSDMappingRec: Record "Hosp. Surg. Distrib. Mapping";
            begin
                if Distributor = '' then
                    exit;

                if Distributor <> '' then begin
                    CustomerRec.reset;
                    CustomerRec.SetRange("No.", Distributor);
                    CustomerRec.SetRange("NTS Distributor", true);
                    CustomerRec.FindFirst();
                end;

                HSDMappingRec.SetRange(Surgeon, Surgeon);
                HSDMappingRec.SetFilter(Distributor, '<>%1&<>%2', Distributor, '');
                if HSDMappingRec.FindFirst() then
                    Error('This surgeon is already assigned to a different distributor.');
            end;

        }
    }
    keys
    {
        key(PK; Hospital, Surgeon)
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
        fieldgroup(DropDown; Hospital, Surgeon, Distributor)
        {
        }
        fieldgroup(Brick; Hospital, Surgeon, Distributor)
        {
        }
    }

    var
        SurgeonRec: Record "NTS Surgeon";
        CustomerRec: Record Customer;

}
