tableextension 52116 "NTS Transfer Line" extends "Transfer Line"
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


        modify("Item No.")
        {
            trigger OnAfterValidate()
            var
                ItemRec: Record Item;
                LocationRec: Record Location;
            begin
                if ItemRec.Get(Rec."Item No.") then begin
                    case ItemRec.PartStatus of
                        ItemRec.PartStatus::Released:
                            Error('Item %1 Status is Released. Item status must be Approved before it can be transferred.', Rec."Item No.");
                        ItemRec.PartStatus::Obsolete:
                            if LocationRec.Get(Rec."Transfer-to Code") then
                                if not LocationRec."NTS IS Finished Goods Location" then
                                    Error('Item %1 Status is Obsolete. Obsolete items can only be transferred to Nexxt Spines Finished Goods Location.', Rec."Item No.");
                    end;
                end;
            end;
        }
    }
}
