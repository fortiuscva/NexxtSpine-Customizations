tableextension 52103 "NTS Sales Invoice Header" extends "Sales Invoice Header"
{
    fields
    {
        field(52100; "NTS Requested Delivery Date"; Date)
        {
            Caption = 'Requested Delivery Date';
            DataClassification = ToBeClassified;
        }
        //already used on Sales header.
        //field(52101; "NTS Surgeon"; Text[100]) 
        //field(52102; "NTS Distributor"; Code[50])
        //field(52103; "NTS Reps"; Text[100])
        //field(52104; "NTS Sales Type"; Enum "NTS Sales Type")
        //field(52105; "NTS DoR Number"; code[20])
    }
}
