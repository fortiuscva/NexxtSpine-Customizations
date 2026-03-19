pageextension 52139 "NTS Transfer Orders" extends "Transfer Orders"
{
    actions
    {
        addfirst(Reporting)
        {
            action("NTS Transfer Backorder Report")
            {
                ApplicationArea = All;
                Caption = 'Backorder';
                Image = Report;
                Promoted = true;
                PromotedCategory = Category8;
                RunObject = report 52116;
            }
        }
    }
}
