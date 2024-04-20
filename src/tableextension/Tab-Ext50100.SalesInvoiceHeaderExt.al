tableextension 50100 "NTS Sales Invoice Header Ext" extends "Sales Invoice Header"
{
    fields
    {
        field(50100; "NTS Promised Delivery Date"; Date)
        {
            Caption = 'Promised Delivery Date';
            DataClassification = ToBeClassified;
        }
    }
}
