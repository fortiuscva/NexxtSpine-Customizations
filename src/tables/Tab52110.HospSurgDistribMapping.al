table 52110 "Hosp. Surg. Distrib. Mapping"
{
    Caption = 'Hospital-Surgeon-Distributor Mapping';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; Hospital; Code[20])
        {
            Caption = 'Hospital';
            TableRelation = Customer where("NTS Is Distributor" = const(false));
        }
        field(2; Surgeon; Text[100])
        {
            Caption = 'Surgeon';
            TableRelation = "NTS Surgeon";
        }
        field(3; Distributor; Code[20])
        {
            Caption = 'Distributor';
            TableRelation = Customer where("NTS Is Distributor" = const(true));

            trigger OnValidate()
            var
                HSDMappingRec: Record "Hosp. Surg. Distrib. Mapping";
            begin
                if Distributor = '' then
                    exit;

                HSDMappingRec.SetRange(Surgeon, Surgeon);
                HSDMappingRec.SetFilter(Distributor, '<>%1', Distributor);
                if not HSDMappingRec.IsEmpty then
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
}
