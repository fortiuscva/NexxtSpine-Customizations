tableextension 52150 "NTS Item Journal Line" extends "Item Journal Line"
{
    fields
    {
        field(52100; "NTS Is Last Operation"; Boolean)
        {
            Caption = 'Is Last Operation';
            DataClassification = CustomerContent;
            Editable = false;
        }
    }
}
