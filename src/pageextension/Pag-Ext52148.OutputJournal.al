pageextension 52148 "NTS Output Journal" extends "Output Journal"
{
    layout
    {
        addafter("Operation No.")
        {
            field("NTS Is Last Operation"; Rec."NTS Is Last Operation")
            {
                ApplicationArea = All;
                Caption = 'Is Last Operation';
            }
        }
    }
}

