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
                Rec."NTS Ship-to Code" := '';
                ClearTransferToAddress();
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
                if "NTS Ship-to Code" <> '' then begin
                    ShipToAddr.Get("NTS Customer Code", "NTS Ship-to Code");
                    SetTransferToAddressFromShipTo(ShipToAddr);
                end else
                    ClearTransferToAddress();
            end;
        }
    }

    local procedure SetTransferToAddressFromShipTo(ShipToAddr: Record "Ship-to Address")
    begin
        Rec."Transfer-to Name" := ShipToAddr.Name;
        Rec."Transfer-to Address" := ShipToAddr.Address;
        Rec."Transfer-to Address 2" := ShipToAddr."Address 2";
        Rec."Transfer-to City" := ShipToAddr.City;
        Rec."Transfer-to Post Code" := ShipToAddr."Post Code";
        Rec."Trsf.-to Country/Region Code" := ShipToAddr."Country/Region Code";
        Rec."Transfer-to County" := ShipToAddr.County;
        Rec."Transfer-to Contact" := ShipToAddr.Contact;
    end;

    local procedure ClearTransferToAddress()
    begin
        Rec."Transfer-to Name" := '';
        Rec."Transfer-to Address" := '';
        Rec."Transfer-to Address 2" := '';
        Rec."Transfer-to City" := '';
        Rec."Transfer-to Post Code" := '';
        Rec."Trsf.-to Country/Region Code" := '';
        Rec."Transfer-to County" := '';
        Rec."Transfer-to Contact" := '';
    end;
}

