/// <summary>
/// PageExtension NTS Inventory Setup (ID 50101) extends Record Inventory Setup.
/// </summary>
pageextension 52101 "NTS Inventory Setup" extends "Inventory Setup"
{
    layout
    {
        addafter("Gen. Journal Templates")
        {
            group("NTS NTSNexxt")
            {
                Caption = 'Nexxt Spine';
                field("NTS Accrued AR GL"; Rec."NTS Accrued Inventory GL")
                {
                    ApplicationArea = all;
                    ToolTip = 'Accured Inventory GL';
                }
                field("NTS Accrued Sales GL"; Rec."NTS Accrued COGS GL")
                {
                    ApplicationArea = all;
                    ToolTip = 'Accured COGS GL';
                }
            }
        }
    }
}
