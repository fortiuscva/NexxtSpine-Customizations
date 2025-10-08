pageextension 52119 "NTS Item List" extends "Item List"
{
    actions
    {
        addlast(processing)
        {
            action("NTS ImportBOMComponents")
            {
                ApplicationArea = All;
                Caption = 'Import Assembly BOM Components';
                Image = Import;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                PromotedIsBig = true;
                RunObject = xmlport "Import Assembly BOM Components";
            }

        }
    }
}
