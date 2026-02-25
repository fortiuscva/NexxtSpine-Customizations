pageextension 52134 "NTS Item Journal" extends "Item Journal"
{
    actions
    {
        addlast(Processing)
        {
            action("NTS NXT Reclass Inventory")
            {
                ApplicationArea = All;
                Caption = 'Process Negative Adjmnts in Item Journals';
                Image = Process;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                trigger OnAction()
                var
                    InvReclassAdjmts: Report "NTS Inventory Reclass Adjmts.";
                begin
                    InvReclassAdjmts.Run();
                end;
            }
        }
    }
}
