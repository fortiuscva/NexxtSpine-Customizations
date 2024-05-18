/// <summary>
/// PageExtension NTS NTS NTS NTS NTS NTS NTS NTS NTS NTS Sales & Receivables Setup (ID 50101) extends Record Sales & Receivables Setup.
/// </summary>
pageextension 52102 "Sales & Receivables Setup" extends "Sales & Receivables Setup"
{
    layout
    {
        addafter("Dynamics 365 Sales")
        {
            group("NTS NTSNexxt")
            {
                Caption = 'Nexxt Spine';
                field("NTS Accrued AR GL"; Rec."NTS Accrued AR GL")
                {
                    ApplicationArea = all;
                    ToolTip = 'Accured AR GL';
                }
                field("NTS Accrued Sales GL"; Rec."NTS Accrued Sales GL")
                {
                    ApplicationArea = all;
                    ToolTip = 'Accured Sales GL';
                }
                field("NTS Acc. Sale Gen. Templ. Name"; Rec."NTS Acc. Sale Gen. Templ. Name")
                {
                    ApplicationArea = all;
                    ToolTip = 'Accured Sales Template Name';
                }
                field("NTS Acc. Sale Gen. Batch Name"; Rec."NTS Acc. Sale Gen. Batch Name")
                {
                    ApplicationArea = all;
                    ToolTip = 'Accured Sales Batch Name';
                }
            }
        }
    }
}
