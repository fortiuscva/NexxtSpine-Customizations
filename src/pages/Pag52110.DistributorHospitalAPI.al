page 52110 "NTS Distributor Hospital API"
{
    APIGroup = 'adcirrusERP';
    APIPublisher = 'adcirrusERP';
    APIVersion = 'v2.0';
    ApplicationArea = All;
    Caption = 'distributorHospital';
    DelayedInsert = true;
    EntityName = 'distributorHospital';
    EntitySetName = 'distributorHospital';
    PageType = API;
    SourceTable = "NTS Distributor Hospital";

    layout
    {
        area(content)
        {
            repeater(General)
            {

                field(hospitalNo; Rec."Hospital No.")
                {
                    Caption = 'Hospital No.';
                }

            }
        }
    }
}
