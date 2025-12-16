tableextension 52118 "NTS Transfer Header" extends "Transfer Header"
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

        modify("Shipping Agent Code")
        {
            trigger OnAfterValidate()
            var
                ShippingAgent: Record "Shipping Agent";
            begin

                if Rec."Shipping Agent Code" <> '' then begin
                    if ShippingAgent.Get(Rec."Shipping Agent Code") then begin
                        Rec."NTS Tracking URL" := ShippingAgent."Internet Address";
                    end;
                end;
            end;
        }
        field(52132; "NTS Customer Code"; Code[20])
        {
            Caption = 'Customer Code';
            TableRelation = Customer."No.";

            trigger OnValidate()
            begin
                if "NTS Customer Code" <> xRec."NTS Customer Code" then begin
                    Rec.Validate("NTS Ship-to Code", '');
                    UpdateShipToAddress("NTS Customer Code", "NTS Ship-to Code");
                end;
            end;

        }
        field(52133; "NTS Ship-to Code"; Code[10])
        {
            Caption = 'Ship-to Code';
            TableRelation = "Ship-to Address".Code where("Customer No." = field("NTS Customer Code"));

            trigger OnValidate()
            var
                ShipToAddr: Record "Ship-to Address";
            begin
                if "NTS Ship-to Code" <> xRec."NTS Ship-to Code" then
                    UpdateShipToAddress("NTS Customer Code", "NTS Ship-to Code");
            end;
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
            CaptionClass = '';
            Caption = 'Ship-to Post Code';
            TableRelation = if ("NTS Ship-to Country/Region Code" = const('')) "Post Code"
            else
            if ("NTS Ship-to Country/Region Code" = filter(<> '')) "Post Code" where("Country/Region Code" = field("NTS Ship-to Country/Region Code"));
            ValidateTableRelation = false;
        }

    }

    local procedure UpdateShipToAddress(CustomerNo: Code[20]; ShipToCode: Code[10])
    var
        ShipToAddress: Record "Ship-to Address";
        CustomerRec: Record Customer;
    begin
        if (CustomerNo <> '') and (ShipToCode <> '') then begin
            ShipToAddress.Get(CustomerNo, ShipToCode);
            Rec."NTS Ship-to Name" := ShipToAddress.Name;
            Rec."NTS Ship-to Address" := ShipToAddress.Address;
            Rec."NTS Ship-to Address 2" := ShipToAddress."Address 2";
            Rec."NTS Ship-to City" := ShipToAddress.City;
            Rec."NTS Ship-to Post Code" := ShipToAddress."Post Code";
            Rec."NTS Ship-to Country/Region Code" := ShipToAddress."Country/Region Code";
            Rec."NTS Ship-to County" := ShipToAddress.County;
            Rec."NTS Ship-to Contact" := ShipToAddress.Contact;
            Rec."NTS Ship-to Phone No." := ShipToAddress."Phone No.";
        end else if CustomerNo <> '' then begin
            CustomerRec.Get(CustomerNo);
            Rec."NTS Ship-to Address" := CustomerRec.Address;
            Rec."NTS Ship-to Address 2" := CustomerRec."Address 2";
            Rec."NTS Ship-to City" := CustomerRec.City;
            Rec."NTS Ship-to Post Code" := CustomerRec."Post Code";
            Rec."NTS Ship-to Country/Region Code" := CustomerRec."Country/Region Code";
            Rec."NTS Ship-to County" := CustomerRec.County;
            Rec."NTS Ship-to Contact" := CustomerRec.Contact;
            Rec."NTS Ship-to Phone No." := CustomerRec."Phone No.";
        end else begin
            Rec."NTS Ship-to Name" := '';
            Rec."NTS Ship-to Address" := '';
            Rec."NTS Ship-to Address 2" := '';
            Rec."NTS Ship-to City" := '';
            Rec."NTS Ship-to Post Code" := '';
            Rec."NTS Ship-to Country/Region Code" := '';
            Rec."NTS Ship-to County" := '';
            Rec."NTS Ship-to Contact" := '';
            Rec."NTS Ship-to Phone No." := '';
        end;
    end;
}

