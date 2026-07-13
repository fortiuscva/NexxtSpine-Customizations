tableextension 52148 "SFI Employee Approval Mapping" extends "SFI Employee Approval Mapping"
{
    fields
    {
        field(52100; "NTS Unposted Time"; Decimal)
        {
            CalcFormula = Sum("SFI Time Card Line"."Total Time (Hours)" WHERE("Employee No." = FIELD("Manages No.")));
            Caption = 'Unposted Time (Hours)';
            Editable = false;
            FieldClass = FlowField;
        }
    }
}
