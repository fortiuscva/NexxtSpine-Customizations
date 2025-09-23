table 52112 "NTS DOR Line"
{
    Caption = 'DOR Line';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Document No."; Code[20])
        {
            Caption = 'Document No.';
            TableRelation = "NTS DOR Header"."No.";
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(3; "Item No."; Code[20])
        {
            Caption = 'Item';
            TableRelation = Item."No." where("Assembly BOM" = const(false));
            trigger OnLookup()
            var
                DORHeader: Record "NTS DOR Header";
                AssemblyHeader: Record "Assembly Header";
                BOMComponent: Record "BOM Component";
                ItemRec: Record Item;
                TempItem: Record Item temporary;
            begin
                DORHeader.Get("Document No.");
                BOMComponent.SetRange("Parent Item No.", DORHeader."Set Name");
                if Page.RunModal(0, BOMComponent) = Action::LookupOK then
                    "Item No." := BOMComponent."No.";
                ValidateItemNo();
                // if BOMComponent.FindSet() then
                //     repeat
                //         ItemRec.Get(BOMComponent."No.");
                //         TempItem := ItemRec;
                //         TempItem.Insert();
                //     until BOMComponent.Next() = 0;

                // if PAGE.RunModal(0, TempItem) = ACTION::LookupOK then
                //     "Item No." := TempItem."No.";
            end;

            trigger OnValidate()
            begin
                ValidateItemNo();
            end;
        }
        field(4; Quantity; Integer)
        {
            Caption = 'Quantity';
        }
        field(5; "Lot No."; Code[50])
        {
            Caption = 'Lot No.';
            //TableRelation = "Lot No. Information"."Lot No." where("Item No." = field("Item No."));
            trigger OnValidate()
            var
                NTSFunctions: Codeunit "NTS NexxtSpine Functions";
            begin
                NTSFunctions.GetAndValidateLOTSerialCombo(Rec."Item No.", Rec."Lot No.", '');
            end;

            trigger OnLookup()
            begin
                ItemTrackingMgt.LookupTrackingNoInfo("Item No.", '', ItemTrackingType::"Lot No.", "Lot No.");
            end;
        }
        field(6; Consumed; Boolean)
        {
            Caption = 'Consumed';
            DataClassification = CustomerContent;
        }
        field(10; "Serial No."; Code[50])
        {
            Caption = 'Serial No.';
            trigger OnLookup()
            begin
                ItemTrackingMgt.LookupTrackingNoInfo("Item No.", '', ItemTrackingType::"Serial No.", "Serial No.");
            end;
        }

    }
    keys
    {
        key(PK; "Document No.", "Line No.")
        {
            Clustered = true;
        }
    }

    var
        ItemTrackingMgt: Codeunit "Item Tracking Management";
        ItemTrackingType: Enum "Item Tracking Type";

    procedure ValidateItemNo()
    begin

    end;
}
