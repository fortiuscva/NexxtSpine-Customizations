page 52119 "NTS DoR Order"
{
    ApplicationArea = All;
    Caption = 'DoR Order';
    PageType = Document;
    SourceTable = "NTS DoR Header";

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';
                field("DoR Number"; Rec."DoR Number")
                {
                    ToolTip = 'Specifies the value of the DoR Number field.', Comment = '%';
                }
                field(Customer; Rec.Customer)
                {
                    ToolTip = 'Specifies the value of the Customer field.', Comment = '%';
                }

                field("Serial Number"; Rec."Serial Number")
                {
                    ToolTip = 'Specifies the value of the Serial Number field.', Comment = '%';
                }
                field("Set Name"; Rec."Set Name")
                {
                    ToolTip = 'Specifies the value of the Set Name field.', Comment = '%';
                }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the value of the Status field.', Comment = '%';
                }
                field(Surgeon; Rec.Surgeon)
                {
                    ToolTip = 'Specifies the value of the Surgeon field.', Comment = '%';
                }
                field(Distributor; Rec.Distributor)
                {
                    ToolTip = 'Specifies the value of the Distributor field.', Comment = '%';
                }
                field(Reps; Rec.Reps)
                {
                    ToolTip = 'Specifies the value of the Reps field.', Comment = '%';
                }
                field("Surgery Date"; Rec."Surgery Date")
                {
                    ToolTip = 'Specifies the value of the Surgery Date field.', Comment = '%';
                }
            }
            part(DoRLinesPart; "NTS DoR Subform")
            {
                ApplicationArea = All;
                SubPageLink = "DoR Number" = field("DoR Number");
            }

        }
    }
}
