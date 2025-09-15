pageextension 52118 "NTS Sales Order List" extends "Sales Order List"
{
    actions
    {
        addlast("F&unctions")
        {
            action("NTS CreateTransferOrder")
            {
                Caption = 'Create Transfer';
                Image = Create;
                ApplicationArea = All;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                trigger OnAction()
                var
                    NTSFunctions: Codeunit "NTS NexxtSpine Functions";
                begin
                    if not Confirm('Do you want to Create Transfer Order?') then
                        exit;
                    NTSFunctions.CreateTransferOrder(Rec);
                end;
            }
        }
    }
}
