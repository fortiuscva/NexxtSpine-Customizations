page 52112 "NTS Distributor Location API"
{
    APIGroup = 'adcirrusERP';
    APIPublisher = 'adcirrusERP';
    APIVersion = 'v2.0';
    ApplicationArea = All;
    Caption = 'distributorLocation';
    DelayedInsert = true;
    EntityName = 'distributorLocation';
    EntitySetName = 'distributorLocation';
    PageType = API;
    SourceTable = "NTS Distributor Location";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(distributorNo; Rec."Distributor No.")
                {
                    Caption = 'Distributor ID';
                }
                field(locationCode; Rec."Location Code")
                {
                    Caption = 'Location Code';
                }
                field(itemNo; Rec."Item No.")
                {
                    Caption = 'Item No.';
                }
                field(quantity; Rec.Quantity)
                {
                    Caption = 'Quantity';
                }
            }
        }
    }
}
