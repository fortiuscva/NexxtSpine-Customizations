page 52107 "NTS Distributor Location"
{
    ApplicationArea = All;
    Caption = 'Distributor Location';
    PageType = List;
    SourceTable = "NTS Distributor Location";
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Distributor No."; Rec."Distributor No.")
                {
                    ToolTip = 'Specifies the value of the Distributor No. field.';
                }
                field("Location Code"; Rec."Location Code")
                {
                    ToolTip = 'Specifies the value of the Location Code field.';
                }
                field("Item No."; Rec."Item No.")
                {
                    ToolTip = 'Specifies the value of the Item No. field.';
                }
                field(Quantity; Rec."Quantity")
                {
                    ToolTip = 'Specifies the value of the Quantity field.';
                }
            }
        }
    }
}
