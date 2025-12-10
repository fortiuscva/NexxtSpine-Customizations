pageextension 52105 "NTS Prod. Order Routing" extends "Prod. Order Routing"
{
    layout
    {
        addafter("Move Time")
        {
            field("NTS IR Sheet 1"; Rec."NTS IR Sheet 1")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the NTS IR Sheet 1 field.';
                Editable = false;
            }
            field("NTS IR Sheet 2"; Rec."NTS IR Sheet 2")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the NTS IR Sheet 2 field.';
                Editable = false;
            }
            field("NTS IR Sheet 3"; Rec."NTS IR Sheet 3")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the NTS IR Sheet 3 field.';
                Editable = false;
            }
        }
        addlast(factboxes)
        {
            part(IRCodesFactbox; "NTS Reference IR Code Factbox")
            {
                Caption = 'Reference IR Code Factbox';
                ApplicationArea = All;
                SubPageLink = "Source Type" = const(5409), "Source Subtype" = field(Status), "Source No." = field("Prod. Order No."), "Source Line No." = field("Routing Reference No.");
            }
        }
    }
}