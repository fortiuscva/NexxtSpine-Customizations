pageextension 52119 "NTS Item List" extends "Item List"
{
    actions
    {
        addlast(processing)
        {
            action("NTS ImportItemLinks")
            {
                Caption = 'Import Links';
                Image = Import;
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Import item links from an Excel file.';
                trigger OnAction()
                begin
                    NexxtSpineFunctionsCU.ReadExcelSheet();
                    NexxtSpineFunctionsCU.ImportLinksForItems();
                end;
            }
        }
    }
    var
        SerialNoNotes: Text;
        NexxtSpineFunctionsCU: Codeunit "NTS NexxtSpine Functions";
}
