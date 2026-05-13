query 52102 "NTS Available Serial Nos."
{
    QueryType = Normal;

    elements
    {
        dataitem(ItemLedgerEntry; "Item Ledger Entry")
        {
            filter(ItemNoFilter; "Item No.")
            { }
            filter(RemQtyFilter; "Remaining Quantity")
            { }
            filter(SerialFilter; "Serial No.")
            { }
            filter(OpenFilter; Open)
            { }
            column(Item_No_; "Item No.")
            { }
            column(Serial_No_; "Serial No.")
            { }
            column(Open; Open)
            { }
            column(Remaining_Quantity; "Remaining Quantity")
            {
                Method = Sum;
            }
        }
    }
}