tableextension 52131 "NTS Production Order" extends "Production Order"
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
        field(50105; "NTS Height/Depth"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Height/Depth';
            TableRelation = "IMP Height/Depth";
        }


        field(50106; "NTS System Name"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'System Name';
            TableRelation = "IMP System Name";
        }

        field(50107; "NTS Sterile Product"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Sterile Product';
            TableRelation = "IMP Sterile Product";
        }


        field(50108; "NTS IFU Number"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'IFU Number';
            TableRelation = "IMP IFU Number";
        }

    }
}
