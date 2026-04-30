pageextension 52103 "NTS Posted Sales Invoice Ext" extends "Posted Sales Invoice"
{
    layout
    {
        addafter("Order No.")
        {
            field("NTS Requested Delivery Date"; Rec."NTS Requested Delivery Date")
            {
                ToolTip = 'Requested Delivery Date';
                ApplicationArea = all;
            }
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
        addafter("Posting Date")
        {
            field("NTS Order Date"; Rec."Order Date")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Order Date field.', Comment = '%';
            }
        }
    }
}
