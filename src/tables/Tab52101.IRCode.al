table 52101 "NTS IR Code"
{
    Caption = 'IR/IP Code';
    DataClassification = CustomerContent;
    LookupPageId = "NTS IR Codes";
    DrillDownPageId = "NTS IR Codes";

    fields
    {
        field(1; "Code"; Code[100])
        {
            Caption = 'Code';
        }
        field(2; "IR Number"; Code[20])
        {
            Caption = 'IR/IP Number';
            trigger OnValidate()
            begin
                UpdateIRIPType();
            end;
        }
        field(3; "IR Sheet Name"; Text[80])
        {
            Caption = 'IR/IP Sheet Name';
        }
        field(4; Link; Text[2048])
        {
            Caption = 'Link';
        }
        field(5; "File Name"; Text[2048])
        {
            Caption = 'File Name';
        }
        field(18; "IR/IP Type"; Enum "NTS IR/IP Type")
        {
            Caption = 'IR/IP Type';
        }
    }

    keys
    {
        key(Key1; Code)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    procedure UpdateIRIPType()
    begin
        if ("IR Number" <> xRec."IR Number") then begin
            if "IR Number" <> '' then begin
                if CopyStr(rec."IR Number", 1, 2) = 'IR' then
                    rec."IR/IP Type" := rec."IR/IP Type"::IR
                else if CopyStr(rec."IR Number", 1, 2) = 'IP' then
                    rec."IR/IP Type" := rec."IR/IP Type"::IP
                else
                    Validate(rec."IR/IP Type", rec."IR/IP Type"::" ");
            end else
                Validate(rec."IR/IP Type", rec."IR/IP Type"::" ");

        end;
    end;
}