pageextension 52137 "NTS Posted Assembly Orders" extends "Posted Assembly Orders"
{
    layout
    {
        addafter("Unit Cost")
        {
            field("NTS Reversed"; Rec.Reversed)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies if the posted assembly order has been undone.';
            }
        }
    }
}
