pageextension 52104 "NTS Item Card" extends "Item Card"
{
    layout
    {
        addlast(factboxes)
        {
            part(IRCodesFactbox; "NTS IR Codes Factbox")
            {
                Caption = 'IR Codes Factbox';
                ApplicationArea = All;
            }
        }
        addlast(Item)
        {
            field("Material #1"; Rec."Material #1")
            {
                ApplicationArea = All;
            }
            field("Material #2"; Rec."Material #2")
            {
                ApplicationArea = All;
            }
            field("Material #3"; Rec."Material #3")
            {
                ApplicationArea = All;
            }
            field("Material #4"; Rec."Material #4")
            {
                ApplicationArea = All;
            }
            field("Material #5"; Rec."Material #5")
            {
                ApplicationArea = All;
            }
            field("Patent #1"; Rec."Patent #1")
            {
                ApplicationArea = All;
            }

            field("Patent #2"; Rec."Patent #2")
            {
                ApplicationArea = All;
            }

            field("Patent #3"; Rec."Patent #3")
            {
                ApplicationArea = All;
            }
            field("Patent #4"; Rec."Patent #4")
            {
                ApplicationArea = All;
            }

            field("Patent #5"; Rec."Patent #5")
            {
                ApplicationArea = All;
            }
            field("NTS Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
            {

                Caption = 'Global Dimension 1 Code';
                ApplicationArea = all;
            }
            field("NTS Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
            {

                Caption = 'Global Dimension 2 Code';
                ApplicationArea = all;
            }
        }
        addbefore("Manufacturing Policy")
        {
            field("NTS Purchase To Production"; Rec."NTS Purchase To Production")
            {
                Caption = 'Purchase To Production';
                ApplicationArea = All;
            }
        }
    }
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
    trigger OnAfterGetRecord()
    begin
        CurrPage.IRCodesFactbox.Page.InitValues(Rec."Routing No.");
        CurrPage.IRCodesFactbox.Page.SummarizeIRCodes();
    end;

    trigger OnOpenPage()
    begin
        CurrPage.IRCodesFactbox.Page.InitValues(Rec."Routing No.");
        CurrPage.IRCodesFactbox.Page.SummarizeIRCodes();
    end;

    var
        SerialNoNotes: Text;
        NexxtSpineFunctionsCU: Codeunit "NTS NexxtSpine Functions";
}