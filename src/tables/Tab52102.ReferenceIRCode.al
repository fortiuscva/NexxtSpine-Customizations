table 52102 "NTS Reference IR Code"
{
    Caption = 'Reference IR Code';
    DataClassification = ToBeClassified;
    LookupPageId = "NTS Reference IR Codes";
    DrillDownPageId = "NTS Reference IR Codes";

    fields
    {
        field(1; "Source Type"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'Source Type';
        }
        field(2; "Source Subtype"; Enum "Production Order Status")
        {
            DataClassification = ToBeClassified;
            Caption = 'Source Subtype';
        }
        field(3; "Source No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Source No.';
        }
        field(4; "Source Line No."; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'Source Line No.';
        }
        field(5; "Source Subline No."; Integer)
        {
            Caption = 'Source Subline No.';
        }
        field(11; "Code"; Code[100])
        {
            Caption = 'Code';
        }
        field(12; "IR Number"; Code[20])
        {
            Caption = 'IR Number';
        }
        field(13; "IR Sheet Name"; Text[80])
        {
            Caption = 'IR Sheet Name';
        }
        field(14; Link; Text[2048])
        {
            Caption = 'Link';
        }
        field(15; "Operation No."; Code[20])
        {
            Caption = '"Operation No."';
        }
        field(16; "Mobile Link"; text[2048])
        {
            Caption = 'Mobile Link';
        }
    }
    keys
    {
        key(PK; "Source Type", "Source Subtype", "Source No.", "Source Line No.", "Source Subline No.", Code, "Operation No.")
        {
            Clustered = true;
        }
    }
}