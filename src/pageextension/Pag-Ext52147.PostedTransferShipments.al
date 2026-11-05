pageextension 52147 "NTS Posted Transfer Shipments" extends "Posted Transfer Shipments"
{
    layout
    {
        addafter("No.")
        {
            field("NTS Transfer Order No."; Rec."Transfer Order No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Transfer Order No. field.', Comment = '%';
            }
        }
    }
}
