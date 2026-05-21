tableextension 52147 "NTS Posted Assembly Line" extends "Posted Assembly Line"
{
    fields
    {
        field(52134; "NTS Qty Reversed"; Decimal)
        {
            Caption = 'Qty. Reversed';
            DecimalPlaces = 0 : 5;
            Editable = false;
            DataClassification = CustomerContent;
        }
    }
}
