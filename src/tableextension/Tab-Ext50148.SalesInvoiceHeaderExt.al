tableextension 50148 "NTS Sales Invoice Header Ext" extends "Sales Invoice Header"
{
    fields
    {
        field(50100; "NTS Requested Delivery Date"; Date)
        {
            Caption = 'Requested Delivery Date';
            DataClassification = ToBeClassified;
        }
    }
}
