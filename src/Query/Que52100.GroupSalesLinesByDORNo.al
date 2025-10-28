query 52100 "Group Sales Lines By DOR No."
{
    Caption = 'Group Sales Lines By DOR No.';
    QueryType = Normal;
    OrderBy = ascending(DORNo);

    elements
    {
        dataitem(SalesLine; "Sales Line")
        {

            column(DocumentType; "Document Type") { }
            column(DocumentNo; "Document No.") { }
            column(DORNo; "NTS DOR No.")
            {
            }
            column(Quantity; Quantity)
            {
                Method = sum;
            }

        }
    }


}
