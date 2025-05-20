page 52113 "NTS Item Availability API"
{
    ApplicationArea = all;
    UsageCategory = Lists;
    SourceTable = "NTS Item Availability Snapshot";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(ItemNo; Rec."Item No.") { }
                field(LocationCode; Rec."Location Code") { }
                field(SupplyQty; Rec."Supply Qty") { }
                field(DemandQty; Rec."Demand Qty") { }
                field(AvailableQty; Rec."Available Qty") { }
                field(LastUpdated; Rec."Last Updated") { }
            }
        }
    }
}
