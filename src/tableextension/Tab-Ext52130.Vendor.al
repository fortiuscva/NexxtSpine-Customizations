tableextension 52130 "NTS Vendor" extends Vendor
{
    fields
    {
        field(52100; "NTS Shortcut Dimension 3 Code"; Code[20])
        {
            Caption = 'Shortcut 3 Dimension Code';
            FieldClass = FlowField;
            CalcFormula = Lookup("Default Dimension"."Dimension Value Code" WHERE("Table ID" = CONST(Database::Vendor), "No." = FIELD("No."), "Dimension Code" = CONST('SPECIAL PROJECTS')));
            Editable = false;
        }
    }
}
