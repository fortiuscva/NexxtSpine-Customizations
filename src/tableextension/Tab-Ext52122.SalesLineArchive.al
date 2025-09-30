tableextension 52122 "NTS Sales Line Archive" extends "Sales Line Archive"
{
    fields
    {
        field(52113; "NTS Lot Number"; Code[50])
        {
            Caption = 'Lot Number';
            TableRelation = "Lot No. Information"."Lot No." where("Item No." = field("No."));
        }
        field(52114; "NTS DOR No."; Code[20])
        {
            Caption = 'DOR No.';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(52115; "NTS DOR Line No."; Integer)
        {
            Caption = 'DOR Line No.';
            Editable = false;
            DataClassification = CustomerContent;
        }

        field(52120; "NTS Surgeon"; Code[20])
        {
            caption = 'Surgeon';
            DataClassification = ToBeClassified;
            TableRelation = "Hosp. Surg. Distrib. Mapping".Surgeon where(Hospital = field("Sell-to Customer No."));

        }
        field(52121; "NTS Distributor"; Code[20])
        {
            Caption = 'Distributor';
            Editable = false;
            DataClassification = ToBeClassified;
            TableRelation = Customer."No." where("NTS Distributor" = const(true));
        }
        field(52122; "NTS Reps."; Code[20])
        {
            Caption = 'Reps.';
            TableRelation = Contact."No.";

        }
        field(52124; "NTS Reps. Name"; Text[100])
        {
            Caption = 'Reps. Name';
            DataClassification = CustomerContent;
            Editable = false;
            TableRelation = Contact.Name where("No." = field("NTS Reps."));
            ValidateTableRelation = false;
        }
        field(52125; "NTS Set Name"; Code[20])
        {
            Caption = 'Set Name';
            TableRelation = Item."No." WHERE("Assembly BOM" = CONST(true));
        }
        field(52128; "NTS Set Serial No."; Code[50])
        {
            Caption = 'Set Serial No.';
            TableRelation = "Serial No. Information"."Serial No." where("Item No." = field("NTS Set Name"));
        }
        field(52131; "NTS Set Lot No."; Code[50])
        {
            Caption = 'Set Lot No.';
            TableRelation = "Lot No. Information"."Lot No." where("Item No." = field("NTS Set Name"));
        }

    }
}
