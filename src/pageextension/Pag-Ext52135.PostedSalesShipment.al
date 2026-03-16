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
            field("NTS Surgeon Name"; Rec."NTS Surgeon Name")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Surgeon Name field.', Comment = '%';
            }
            field("NTS Distributor"; Rec."NTS Distributor")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Distributor field.', Comment = '%';
            }
            field("NTS Distributor Name"; Rec."NTS Distributor Name")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Distributor Name field.', Comment = '%';
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
