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
            action("NTS Import OneDrive PDFs")
            {
                ApplicationArea = All;
                Caption = 'Import OneDrive PDFs';
                Image = Import;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Read PDFs from OneDrive Attachments folder and attach them to Items';

                trigger OnAction()
                var
                    OneDriveImport: Codeunit "NTS OneDrive PDF Import";
                begin
                    OneDriveImport.ImportPDFFromOneDrive();
                    Message('OneDrive PDF import completed.');
                end;
            }
        }
    }
    var
        SerialNoNotes: Text;
        NexxtSpineFunctionsCU: Codeunit "NTS NexxtSpine Functions";
}
