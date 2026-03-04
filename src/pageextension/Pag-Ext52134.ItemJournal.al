pageextension 52134 "NTS Item Journal" extends "Item Journal"
{
    actions
    {
        addlast(Processing)
        {
            action("NTS NXT Reclass Inventory")
            {
                ApplicationArea = All;
                Caption = 'Process Negative Adj.';
                Image = Process;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                trigger OnAction()
                var
                    CreateNegativeAdj: Report "NTS Create Negative Adj.";
                begin
                    CreateNegativeAdj.SetInitialValues(Rec."Journal Template Name", Rec."Journal Batch Name");
                    CreateNegativeAdj.Run();
                end;
            }
        }
    }
}
