tableextension 52103 "NTS Sales Invoice Header" extends "Sales Invoice Header"
{
    fields
    {
        field(52100; "NTS Requested Delivery Date"; Date)
        {
            Caption = 'Requested Delivery Date';
            DataClassification = ToBeClassified;
        }
        field(52101; "NTS Surgeon"; Code[20])
        {
            caption = 'Surgeon';
            DataClassification = CustomerContent;
            TableRelation = "Hosp. Surg. Distrib. Mapping".Surgeon where(Hospital = field("Sell-to Customer No."));
        }
        field(52102; "NTS Distributor"; Code[20])
        {
            Caption = 'Distributor';
            Editable = false;
            DataClassification = CustomerContent;
            TableRelation = Customer."No." where("NTS Is Distributor" = const(true));
        }
        field(52103; "NTS Reps."; Code[20])
        {
            Caption = 'Reps.';
            TableRelation = Contact."No.";
            DataClassification = CustomerContent;
        }
        field(52104; "NTS Sales Type"; Enum "NTS Sales Type")
        {
            Caption = 'Sales Type';
            DataClassification = CustomerContent;
        }
        field(52105; "NTS DoR Number"; code[20])
        {
            Caption = 'DoR Number';
            Editable = false;
            TableRelation = "NTS DOR Header"."No.";

        }
        field(52106; "NTS Set Name"; Code[20])
        {
            Caption = 'Set Name';
            TableRelation = Item."No." WHERE("Assembly BOM" = CONST(true));
        }
        field(52107; "NTS Transfer Order Created"; Boolean)
        {
            Caption = 'Transfer Order Created';
            Editable = false;
            DataClassification = CustomerContent;
        }

        field(52108; "NTS Reps. Name"; Text[100])
        {
            Caption = 'Reps. Name';
            DataClassification = CustomerContent;
            Editable = false;
            TableRelation = Contact.Name where("No." = field("NTS Reps."));
            ValidateTableRelation = false;
        }
    }
}
