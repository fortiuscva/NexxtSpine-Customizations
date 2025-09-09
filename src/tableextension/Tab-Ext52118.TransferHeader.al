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
            TableRelation = "Sales Header"."NTS Set Name";
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
    }

}
