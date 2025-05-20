page 52109 "NTS Distributor Items"
{
    ApplicationArea = All;
    Caption = 'NTS Distributor Items';
    PageType = List;
    SourceTable = "NTS Distributor Location Items";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Distributor No."; Rec."Distributor No.")
                {
                    ToolTip = 'Specifies the value of the Distributor No. field.';
                    Visible = false;
                }
                field("Location Code"; Rec."Location Code")
                {
                    ToolTip = 'Specifies the value of the Location Code field.';
                }
                field("Item No."; Rec."Item No.")
                {
                    ToolTip = 'Specifies the value of the Item No. field.';
                }
            }
        }
    }
}
