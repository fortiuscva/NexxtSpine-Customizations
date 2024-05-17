pageextension 52104 "NTS Source Code Set" extends "Source Code Setup"
{
    layout
    {
        addafter("Cost Accounting")
        {
            group("NTS NTSNexxt")
            {
                Caption = 'Nexxt Spine';
                field("NTS Accure Sales Source Code"; Rec."NTS Accure Sales Source Code")
                {
                    ApplicationArea = all;
                    ToolTip = 'Accure Sales Source Code';
                }

            }
        }
    }
}
