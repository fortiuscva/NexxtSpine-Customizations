pageextension 52146 "NTS User Setup" extends "User Setup"
{
    layout
    {
        addafter("Allow Deferral Posting To")
        {
            field("NTS Allow To Valid. Exp. Date"; Rec."NTS Allow To Valid. Exp. Date")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Allow To Validate Expiration Date field in Tracking Lines.', Comment = '%';
            }
        }
    }
}
