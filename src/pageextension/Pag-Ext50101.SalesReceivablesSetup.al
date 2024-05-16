/// <summary>
/// PageExtension NTS NTS NTS NTS NTS NTS Sales & Receivables Setup (ID 50101) extends Record Sales & Receivables Setup.
/// </summary>
pageextension 50101 "Sales & Receivables Setup" extends "Sales & Receivables Setup"
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
            }
        }
    }
}
