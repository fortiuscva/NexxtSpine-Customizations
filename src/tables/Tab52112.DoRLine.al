table 52112 "NTS DoR Line"
{
    Caption = 'DoR Line';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "DoR Number"; Code[20])
        {
            Caption = 'DoR Number';
            TableRelation = "NTS DoR Header"."DoR Number";
        }
        field(2; "Item No."; Code[20])
        {
            Caption = 'Item';
            TableRelation = Item."No.";
            trigger OnValidate()
            var
                BOMHeader: Record "Assembly Header";
                BOMLine: Record "Assembly Line";
                DoRHeader: Record "NTS DoR Header";
            begin
                // Find if the Item No. is a BOM Component for the Set Item on the DoR Header
                if Rec."DoR Number" = '' then
                    exit;

                // Get the Set Item (assembly)


                if not DoRHeader.Get(Rec."DoR Number") then
                    exit;

                // Find the BOM Header by Set Name
                if BOMHeader.Get(DoRHeader."Set Name") then begin
                    // Find the line for this component
                    BOMLine.SetRange("Document No.", BOMHeader."No.");
                    BOMLine.SetRange("No.", Rec."Item No.");
                    if BOMLine.FindFirst() then begin
                        Rec.Quantity := BOMLine.Quantity; // Set Quantity as per Assembly BOM standard qty
                    end else begin
                        Rec.Quantity := 0; // Not found—clear quantity or set default
                    end;
                end else
                    Rec.Quantity := 0; // No BOM, clear quantity
            end;
        }
        field(3; Quantity; Integer)
        {
            Caption = 'Quantity';
        }
        field(4; "Lot Number"; Code[50])
        {
            Caption = 'Lot Number';
            TableRelation = "Lot No. Information"."Lot No." where("Item No." = field("Item No."));
        }
    }
    keys
    {
        key(PK; "DoR Number", "Item No.")
        {
            Clustered = true;
        }
    }
}
