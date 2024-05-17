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
                field("NTS Accrued Inventory GL"; Rec."NTS Accrued Inventory GL")
                {
                    ApplicationArea = all;
                    ToolTip = 'Accured Inventory GL';
                }
                field("NTS Accrued COGS GL"; Rec."NTS Accrued COGS GL")
                {
                    ApplicationArea = all;
                    ToolTip = 'Accured COGS GL';
                }
                field("NTS Acc. Cost Gen. Templ. Name"; Rec."NTS Acc. Cost Gen. Templ. Name")
                {
                    ApplicationArea = all;
                    ToolTip = 'Accured Cst Template Name';
                }
                field("NTS Acc. Cost Gen. Batch Name"; Rec."NTS Acc. Cost Gen. Batch Name")
                {
                    ApplicationArea = all;
                    ToolTip = 'Accured Cost Batch Name';
                }
            }
        }
    }

}
