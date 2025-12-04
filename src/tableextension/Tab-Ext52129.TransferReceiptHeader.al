tableextension 52129 "NTS Transfer Receipt Header" extends "Transfer Receipt Header"
{
    fields
    {
        field(52100; "NTS Tracking No."; Code[100])
        {
            Caption = 'Tracking No.';
            DataClassification = ToBeClassified;
        }
        field(52101; "NTS Tracking URL"; Text[250])
        {
            Caption = 'Tracking URL';
            DataClassification = ToBeClassified;
        }
        field(52102; "NTS Set Name"; code[20])
        {
            Caption = 'Set Name';
            DataClassification = ToBeClassified;
            TableRelation = Item."No." WHERE("Assembly BOM" = CONST(true));
        }
        field(52103; "NTS DOR No."; Code[20])
        {
            Caption = 'DOR No.';
            DataClassification = CustomerContent;
        }
        field(52110; "NTS Sales Order No."; Code[20])
        {
            Caption = 'Sales Order No.';
            DataClassification = CustomerContent;
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
        field(52132; "NTS Customer Code"; Code[20])
        {
            Caption = 'Customer Code';
            TableRelation = Customer."No.";
        }
        field(52133; "NTS Ship-to Code"; Code[10])
        {
            Caption = 'Ship-to Code';
            TableRelation = "Ship-to Address".Code where("Customer No." = field("NTS Customer Code"));
        }
        field(52134; "NTS Ship-to Name"; Text[100])
        {
            Caption = 'Ship-to Name';
        }
        field(52135; "NTS Ship-to Name 2"; Text[50])
        {
            Caption = 'Ship-to Name 2';
        }
        field(52136; "NTS Ship-to Address"; Text[100])
        {
            Caption = 'Ship-to Address';
        }
        field(52137; "NTS Ship-to Address 2"; Text[50])
        {
            Caption = 'Ship-to Address 2';
        }
        field(52138; "NTS Ship-to City"; Text[30])
        {
            Caption = 'Ship-to City';
            TableRelation = if ("NTS Ship-to Country/Region Code" = const('')) "Post Code".City
            else
            if ("NTS Ship-to Country/Region Code" = filter(<> '')) "Post Code".City where("Country/Region Code" = field("NTS Ship-to Country/Region Code"));
            ValidateTableRelation = false;
        }
        field(52139; "NTS Ship-to Contact"; Text[100])
        {
            Caption = 'Ship-to Contact';
        }
        field(52140; "NTS Ship-to County"; Text[30])
        {
            CaptionClass = '5,4,' + "NTS Ship-to Country/Region Code";
            Caption = 'Ship-to County';
        }
        field(52141; "NTS Ship-to Country/Region Code"; Code[10])
        {
            Caption = 'Ship-to Country/Region Code';
            TableRelation = "Country/Region";
        }

        field(52142; "NTS Ship-to Phone No."; Text[30])
        {
            Caption = 'Ship-to Phone No.';
            ExtendedDatatype = PhoneNo;
        }
        field(52143; "NTS Ship-to Post Code"; Code[20])
        {
            Caption = 'Ship-to Post Code';
            TableRelation = if ("NTS Ship-to Country/Region Code" = const('')) "Post Code"
            else
            if ("NTS Ship-to Country/Region Code" = filter(<> '')) "Post Code" where("Country/Region Code" = field("NTS Ship-to Country/Region Code"));
            ValidateTableRelation = false;
        }
    }
}
