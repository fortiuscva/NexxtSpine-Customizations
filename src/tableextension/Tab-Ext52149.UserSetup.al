tableextension 52149 "NTS User Setup" extends "User Setup"
{
    fields
    {
        field(52100; "NTS Allow To Valid. Exp. Date"; Boolean)
        {
            Caption = 'Allow To Validate Exp. Date';
            DataClassification = CustomerContent;
        }
        field(52101; "NTS Access To Res. Entry Page"; Boolean)
        {
            Caption = 'Access To Reservation Entries Page';
            DataClassification = CustomerContent;
        }
    }
}
