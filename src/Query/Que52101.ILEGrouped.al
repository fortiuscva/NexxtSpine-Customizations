query 52101 "NTS ILE Grouped"
{
    QueryType = Normal;

    elements
    {
        dataitem(ItemLedgerEntry; "Item Ledger Entry")
        {
            DataItemTableFilter =
                Open = const(true),
                "Remaining Quantity" = filter(> 0),
                "Entry Type" = filter(<> "Negative Adjmt.");

            column(ItemNo; "Item No.") { }
            column(LocationCode; "Location Code") { }
            column(VariantCode; "Variant Code") { }
            column(LotNo; "Lot No.") { }
            column(SerialNo; "Serial No.") { }
            column(ExpirationDate; "Expiration Date") { }
            column(RemainingQty; "Remaining Quantity")
            {
                Method = Sum;
            }
            // column(UOM; "Unit of Measure Code") { }

            // column(Dim1; "Global Dimension 1 Code") { }
            // column(Dim2; "Global Dimension 2 Code") { }
        }
    }
}