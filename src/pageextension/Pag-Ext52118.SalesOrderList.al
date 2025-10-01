pageextension 52118 "NTS Sales Order List" extends "Sales Order List"
{
    layout
    {
        addafter("Sell-to Customer Name")
        {
            field("NTS DoR Number"; Rec."NTS DOR No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the DoR Number field.', Comment = '%';
            }
        }
    }

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
                    // NTSFunctions.CreateTransferOrder(Rec);
                    NTSFunctions.CreateTransferOrderforMultipleDoRs(Rec);
                end;
            }
        }
    }
}
