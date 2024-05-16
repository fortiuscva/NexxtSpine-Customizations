tableextension 52103 "NTS Sales Invoice Header" extends "Sales Invoice Header"
{
    fields
    {
        field(52100; "NTS Requested Delivery Date"; Date)
        {
            Caption = 'Requested Delivery Date';
            DataClassification = ToBeClassified;
        }
    }
}
