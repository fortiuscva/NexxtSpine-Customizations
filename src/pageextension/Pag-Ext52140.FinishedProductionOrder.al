pageextension 52140 "NTS Finished Production Order" extends "Finished Production Order"
{
    actions
    {
        addfirst(Reporting)
        {
            action("NTS FInished Prod. Order")
            {
                ApplicationArea = All;
                Caption = 'Finished Production Order';
                Image = Report;
                Promoted = true;
                PromotedCategory = Report;

                trigger OnAction()
                var
                    ProdOrder: Record "Production Order";
                begin
                    CurrPage.SetSelectionFilter(ProdOrder);
                    Report.RunModal(Report::"NTS Finished Production Order", true, true, ProdOrder);
                end;
            }
        }
    }
}
