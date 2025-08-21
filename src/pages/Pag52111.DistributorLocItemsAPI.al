page 52111 "NTS Distributor Loc.Items API"
{
    APIGroup = 'adcirrusERP';
    APIPublisher = 'adcirrusERP';
    APIVersion = 'v2.0';
    ApplicationArea = All;
    Caption = 'distributorLocationItems';
    DelayedInsert = true;
    EntityName = 'distributorItems';
    EntitySetName = 'distributorItems';
    PageType = API;
    SourceTable = "NTS Distributor Location Items";

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(distributorNo; Rec."Distributor No.")
                {
                    Caption = 'Distributor No.';
                }
                field(locationCode; Rec."Location Code")
                {
                    Caption = 'Location Code';
                }
                field(itemNo; Rec."Item No.")
                {
                    Caption = 'Item No.';
                }
                field(distributorName; Rec."Distributor Name")
                {
                }
                field(locationName; Rec."Location Name")
                {
                }
                field(itemDescription; Rec."Item Description")
                {
                }
                field(unitPrice; Rec.GetUnitPriceOrDiscount(true))
                {
                }
                field(discountPct; Rec.GetUnitPriceOrDiscount(false))
                {
                }
            }
        }
    }
}
