pageextension 52135 "NTS Posted Sales Shipment" extends "Posted Sales Shipment"
{
    layout
    {
        addlast(General)
        {

            field("NTS Surgeon"; Rec."NTS Surgeon")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Surgeon field.', Comment = '%';
            }
            field("NTS Distributor"; Rec."NTS Distributor")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Distributor field.', Comment = '%';
            }
            field("NTS Reps."; Rec."NTS Reps.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Reps. field.', Comment = '%';
            }
            field("NTS Reps. Name"; Rec."NTS Reps. Name")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Reps. Name field.', Comment = '%';
            }
        }
    }
}
