tableextension 52101 "NTS Sales & Receivables Setup" extends "Sales & Receivables Setup"
{
    fields
    {
        field(52100; "NTS Accrued AR GL"; Code[10])
        {
            Caption = 'Accrued AR GL';
            DataClassification = ToBeClassified;
            TableRelation = "G/L Account";
        }
        field(52101; "NTS Accrued Sales GL"; Code[10])
        {
            Caption = 'Accrued Sales GL';
            DataClassification = ToBeClassified;
            TableRelation = "G/L Account";
        }
        field(52102; "NTS Acc. Sale Gen. Templ. Name"; code[10])
        {
            caption = 'Accured Sales Gen. Template Name';
            DataClassification = ToBeClassified;
            TableRelation = "Gen. Journal Template";
        }
        field(52103; "NTS Acc. Sale Gen. Batch Name"; code[10])
        {
            caption = 'Accured Sales Gen. Batch Name';
            DataClassification = ToBeClassified;
            TableRelation = "Gen. Journal Batch".Name where("Journal Template Name" = field("NTS Acc. Sale Gen. Templ. Name"));
        }
    }
}
