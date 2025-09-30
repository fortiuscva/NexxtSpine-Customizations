tableextension 52127 "NTS Transfer Receipt Line" extends "Transfer Receipt Line"
{
    fields
    {
        field(52100; "NTS Sales Order No."; Code[20])
        {
            Caption = 'Sales Order No.';
            DataClassification = CustomerContent;
        }
        field(52101; "NTS Sales Order Line No."; Integer)
        {
            Caption = 'Sales Order Line No.';
            DataClassification = CustomerContent;
        }
        field(52102; "NTS DOR No."; Code[20])
        {
            Caption = 'DOR No.';
            DataClassification = CustomerContent;
        }
        field(52103; "NTS DOR Line No."; Integer)
        {
            Caption = 'DOR Line No.';
            DataClassification = CustomerContent;
        }
        field(52104; "NTS Set Name"; Code[20])
        {
            Caption = 'Set Name';
            TableRelation = Item."No." WHERE("Assembly BOM" = CONST(true));
        }

        field(52120; "NTS Surgeon"; Code[20])
        {
            caption = 'Surgeon';
            DataClassification = CustomerContent;
            TableRelation = "NTS Surgeon".Code;

        }
        field(52121; "NTS Distributor"; Code[20])
        {
            Caption = 'Distributor';
            DataClassification = CustomerContent;
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
