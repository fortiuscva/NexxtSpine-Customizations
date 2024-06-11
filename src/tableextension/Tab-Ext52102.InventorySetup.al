tableextension 52102 "NTS Inventory Setup" extends "Inventory Setup"
{
    fields
    {
        field(52100; "NTS Accrued Inventory GL"; Code[10])
        {
            Caption = 'Accrued Inventory GL';
            DataClassification = ToBeClassified;
            TableRelation = "G/L Account";
        }
        field(52101; "NTS Accrued COGS GL"; Code[10])
        {
            Caption = 'Accrued COGS GL';
            DataClassification = ToBeClassified;
            TableRelation = "G/L Account";
        }
        field(52102; "NTS Acc. COST Gen. Templ. Name"; code[10])
        {
            caption = 'Accured Cost Gen. Template Name';
            DataClassification = ToBeClassified;
            TableRelation = "Gen. Journal Template";
        }
        field(52103; "NTS Acc. Cost Gen. Batch Name"; code[10])
        {
            caption = 'Accured Cost Gen. Batch Name';
            DataClassification = ToBeClassified;
            TableRelation = "Gen. Journal Batch".Name where("Journal Template Name" = field("NTS Acc. Cost Gen. Templ. Name"));
        }

    }
}
