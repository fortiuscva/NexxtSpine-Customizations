tableextension 52132 "NTS IWX LP Header" extends "IWX LP Header"
{
    fields
    {
        field(52100; "NTS Transfer-from Code"; Code[10])
        {
            Caption = 'Transfer-from Code';
            TableRelation = Location where("Use As In-Transit" = const(false));
        }
        field(52101; "NTS Transfer-from Name"; Text[100])
        {
            Caption = 'Transfer-from Name';
        }
        field(52102; "NTS Transfer-from Name 2"; Text[50])
        {
            Caption = 'Transfer-from Name 2';
        }
        field(52103; "NTS Transfer-from Address"; Text[100])
        {
            Caption = 'Transfer-from Address';
        }
        field(52104; "NTS Transfer-from Address 2"; Text[50])
        {
            Caption = 'Transfer-from Address 2';
        }
        field(52105; "NTS Transfer-from Post Code"; Code[20])
        {
            Caption = 'Transfer-from Post Code';
            TableRelation = if ("NTS Trsf.-from Country/Region Code" = const('')) "Post Code"
            else
            if ("NTS Trsf.-from Country/Region Code" = filter(<> '')) "Post Code" where("Country/Region Code" = field("NTS Trsf.-from Country/Region Code"));
            ValidateTableRelation = false;
        }
        field(52106; "NTS Transfer-from City"; Text[30])
        {
            Caption = 'Transfer-from City';
            TableRelation = if ("NTS Trsf.-from Country/Region Code" = const('')) "Post Code".City
            else
            if ("NTS Trsf.-from Country/Region Code" = filter(<> '')) "Post Code".City where("Country/Region Code" = field("NTS Trsf.-from Country/Region Code"));
            ValidateTableRelation = false;
        }
        field(52107; "NTS Transfer-from County"; Text[30])
        {
            CaptionClass = '5,7,' + "NTS Trsf.-from Country/Region Code";
            Caption = 'Transfer-from County';
        }
        field(52108; "NTS Trsf.-from Country/Region Code"; Code[10])
        {
            Caption = 'Trsf.-from Country/Region Code';
            TableRelation = "Country/Region";
        }
        field(52109; "NTS Transfer-to Code"; Code[10])
        {
            Caption = 'Transfer-to Code';
            TableRelation = Location where("Use As In-Transit" = const(false));
        }
        field(52110; "NTS Transfer-to Name"; Text[100])
        {
            Caption = 'Transfer-to Name';
        }
        field(52111; "NTS Transfer-to Name 2"; Text[50])
        {
            Caption = 'Transfer-to Name 2';
        }
        field(52112; "NTS Transfer-to Address"; Text[100])
        {
            Caption = 'Transfer-to Address';
        }
        field(52113; "NTS Transfer-to Address 2"; Text[50])
        {
            Caption = 'Transfer-to Address 2';
        }
        field(52114; "NTS Transfer-to Post Code"; Code[20])
        {
            Caption = 'Transfer-to Post Code';
            TableRelation = "Post Code";
            ValidateTableRelation = false;
        }
        field(52115; "NTS Transfer-to City"; Text[30])
        {
            Caption = 'Transfer-to City';
            TableRelation = if ("NTS Trsf.-to Country/Region Code" = const('')) "Post Code".City
            else
            if ("NTS Trsf.-to Country/Region Code" = filter(<> '')) "Post Code".City where("Country/Region Code" = field("NTS Trsf.-to Country/Region Code"));
            ValidateTableRelation = false;
        }
        field(52116; "NTS Transfer-to County"; Text[30])
        {
            CaptionClass = '5,8,' + "NTS Trsf.-to Country/Region Code";
            Caption = 'Transfer-to County';
        }
        field(52117; "NTS Trsf.-to Country/Region Code"; Code[10])
        {
            Caption = 'Trsf.-to Country/Region Code';
            TableRelation = "Country/Region";
        }
        field(52118; "NTS Ship-to Code"; Code[10])
        {
            Caption = 'Ship-to Code';
            //TableRelation = "Ship-to Address".Code where("Customer No." = field("Customer No."));
        }
        field(52119; "NTS Ship-to Name"; Text[100])
        {
            Caption = 'Ship-to Name';
        }
        field(52120; "NTS Ship-to Name 2"; Text[50])
        {
            Caption = 'Ship-to Name 2';
        }
        field(52121; "NTS Ship-to Address"; Text[100])
        {
            Caption = 'Ship-to Address';
        }
        field(52122; "NTS Ship-to Address 2"; Text[50])
        {
            Caption = 'Ship-to Address 2';
        }
        field(52123; "NTS Ship-to City"; Text[30])
        {
            Caption = 'Ship-to City';
            TableRelation = if ("NTS Ship-to Country/Region Code" = const('')) "Post Code".City
            else
            if ("NTS Ship-to Country/Region Code" = filter(<> '')) "Post Code".City where("Country/Region Code" = field("NTS Ship-to Country/Region Code"));
            ValidateTableRelation = false;
        }
        field(52124; "NTS Ship-to Contact"; Text[100])
        {
            Caption = 'Ship-to Contact';
        }
        field(52125; "NTS Ship-to Post Code"; Code[20])
        {
            Caption = 'Ship-to Post Code';
            TableRelation = if ("NTS Ship-to Country/Region Code" = const('')) "Post Code"
            else
            if ("NTS Ship-to Country/Region Code" = filter(<> '')) "Post Code" where("Country/Region Code" = field("NTS Ship-to Country/Region Code"));
            ValidateTableRelation = false;
        }
        field(52126; "NTS Ship-to County"; Text[30])
        {
            CaptionClass = '5,4,' + "NTS Ship-to Country/Region Code";
            Caption = 'Ship-to County';
        }
        field(52127; "NTS Ship-to Country/Region Code"; Code[10])
        {
            Caption = 'Ship-to Country/Region Code';
            TableRelation = "Country/Region";
        }
        field(52128; "NTS Ship-to Phone No."; Text[30])
        {
            Caption = 'Ship-to Phone No.';
            ExtendedDatatype = PhoneNo;
        }
        field(52129; "NTS Transfer-from Contact"; Text[100])
        {
            Caption = 'Transfer-from Contact';
        }
        field(52130; "NTS Transfer-to Contact"; Text[100])
        {
            Caption = 'Transfer-to Contact';
        }
    }
}
