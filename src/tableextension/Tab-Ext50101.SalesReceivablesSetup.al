tableextension 50101 "NTS Sales & Receivables Setup" extends "Sales & Receivables Setup"
{
    fields
    {
        field(50100; "NTS Accrued AR GL"; Code[10])
        {
            Caption = 'Accrued AR GL';
            DataClassification = ToBeClassified;
            TableRelation = "G/L Account";
        }
        field(50101; "NTS Accrued Sales GL"; Code[10])
        {
            Caption = 'Accrued Sales GL';
            DataClassification = ToBeClassified;
            TableRelation = "G/L Account";
        }
    }
}
