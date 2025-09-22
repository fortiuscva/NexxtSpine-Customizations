table 52112 "NTS DOR Line"
{
    Caption = 'DOR Line';
    DataClassification = ToBeClassified;

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
                if BOMComponent.FindSet() then
                    repeat
                        ItemRec.Get(BOMComponent."No.");
                        TempItem := ItemRec;
                        TempItem.Insert();
                    until BOMComponent.Next() = 0;

                if PAGE.RunModal(0, TempItem) = ACTION::LookupOK then
                    "Item No." := TempItem."No.";
            end;
        }
        field(4; Quantity; Integer)
        {
            Caption = 'Quantity';
        }
        field(5; "Lot No."; Code[50])
        {
            Caption = 'Lot No.';
            TableRelation = "Lot No. Information"."Lot No." where("Item No." = field("Item No."));
            trigger OnValidate()
            var
                NTSFunctions: Codeunit "NTS NexxtSpine Functions";
            begin
                NTSFunctions.GetAndValidateLOTSerialCombo(Rec."Item No.", Rec."Lot No.", '');
            end;
        }
        field(6; Consumed; Boolean)
        {
            Caption = 'Consumed';
            DataClassification = CustomerContent;
        }
    }
    keys
    {
        key(PK; "Document No.", "Line No.")
        {
            Clustered = true;
        }
    }
}
