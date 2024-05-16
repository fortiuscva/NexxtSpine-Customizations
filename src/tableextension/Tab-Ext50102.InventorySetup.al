tableextension 50102 "NTS Inventory Setup" extends "Inventory Setup"
{
    fields
    {
        field(50100; "NTS Accrued Inventory GL"; Code[10])
        {
            Caption = 'Accrued Inventory GL';
            DataClassification = ToBeClassified;
            TableRelation = "G/L Account";
        }
        field(50101; "NTS Accrued COGS GL"; Code[10])
        {
            Caption = 'Accrued COGS GL';
            DataClassification = ToBeClassified;
            TableRelation = "G/L Account";
        }

    }
}
