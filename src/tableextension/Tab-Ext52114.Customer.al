tableextension 52114 "NTS Customer" extends Customer
{
    fields
    {
        field(52100; "NTS Distributor"; Boolean)
        {
            Caption = 'Is Distributor';
        }
        field(52101; "NTS Shortcut Dimension 3 Code"; Code[20])
        {
            CaptionClass = '1,2,3';
            Caption = 'Shortcut Dimension 3 Code';
            FieldClass = FlowField;
            CalcFormula = Lookup("Default Dimension"."Dimension Value Code" WHERE("Table ID" = CONST(Database::Customer), "No." = FIELD("No."), "Dimension Code" = CONST('SPECIAL PROJECTS')));
            Editable = false;
        }
    }
}
