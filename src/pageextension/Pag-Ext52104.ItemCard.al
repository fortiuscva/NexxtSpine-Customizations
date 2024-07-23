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
}