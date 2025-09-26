table 52106 "NTS Distributor Location Items"
{
    Caption = 'NTS Distributor Location Items';
    DataClassification = AccountData;

    fields
    {
        field(1; "Distributor No."; Code[20])
        {
            Caption = 'Distributor No.';
            TableRelation = Customer."No." where("NTS Distributor" = const(true));
        }
        field(2; "Location Code"; Code[10])
        {
            Caption = 'Location Code';
            TableRelation = Location.Code;
        }
        field(3; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            TableRelation = Item."No.";
        }
        field(4; "Distributor Name"; Text[100])
        {
            FieldClass = FlowField;
            CalcFormula = lookup(Customer.Name where("No." = field("Distributor No.")));
        }
        field(5; "Location Name"; Text[100])
        {
            FieldClass = FlowField;
            CalcFormula = lookup(Location.Name where(Code = field("Location Code")));
        }
        field(6; "Item Description"; Text[100])
        {
            FieldClass = FlowField;
            CalcFormula = lookup(Item.Description where("No." = field("Item No.")));
        }
    }
    keys
    {
        key(PK; "Distributor No.", "Location Code", "Item No.")
        {
            Clustered = true;
        }
    }
    var
        NTSNexxtSpineFunctions: Codeunit "NTS NexxtSpine Functions";

    procedure GetUnitPriceOrDiscount(blnUnitPrice: Boolean): Decimal
    var
        unitPrice: Decimal;
        discountPct: Decimal;
    begin
        NTSNexxtSpineFunctions.GetUnitPriceAndDiscount("Distributor No.", "Item No.", unitPrice, discountPct);
        if blnUnitPrice then
            exit(unitPrice)
        else
            exit(discountPct);
    end;
}
