tableextension 52115 "NTS Item" extends Item
{
    fields
    {
        field(52100; "Material #1"; Code[25])
        {
            Caption = 'Material #1';
            DataClassification = ToBeClassified;
            TableRelation = "IMP Material"."IMP Code";
        }
        field(52101; "Material #2"; Code[25])
        {
            Caption = 'Material #2';
            DataClassification = ToBeClassified;
            TableRelation = "IMP Material"."IMP Code";
        }
        field(52102; "Material #3"; Code[25])
        {
            Caption = 'Material #3';
            DataClassification = ToBeClassified;
            TableRelation = "IMP Material"."IMP Code";
        }
        field(52103; "Material #4"; Code[25])
        {
            Caption = 'Material #4';
            DataClassification = ToBeClassified;
            TableRelation = "IMP Material"."IMP Code";
        }
        field(52104; "Material #5"; Code[25])
        {
            Caption = 'Material #5';
            DataClassification = ToBeClassified;
            TableRelation = "IMP Material"."IMP Code";
        }
        field(52105; "Patent #1"; Code[25])
        {
            Caption = 'Patent #1';
            DataClassification = ToBeClassified;
            TableRelation = "NTS Patent".Code;
        }

        field(52106; "Patent #2"; Code[25])
        {
            Caption = 'Patent #2';
            DataClassification = ToBeClassified;
            TableRelation = "NTS Patent".Code;
        }
        field(52107; "Patent #3"; Code[25])
        {
            Caption = 'Patent #3';
            DataClassification = ToBeClassified;
            TableRelation = "NTS Patent".Code;
        }
        field(52108; "Patent #4"; Code[25])
        {
            Caption = 'Patent #4';
            DataClassification = ToBeClassified;
            TableRelation = "NTS Patent".Code;
        }
        field(52109; "Patent #5"; Code[25])
        {
            Caption = 'Patent #5';
            DataClassification = ToBeClassified;
            TableRelation = "NTS Patent".Code;
        }
        field(52110; "NTS Purchase To Production"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Purchase To Production';
        }

    }
}
