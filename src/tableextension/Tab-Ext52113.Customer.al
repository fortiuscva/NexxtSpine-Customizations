tableextension 52113 "NTS Customer" extends Customer
{
    fields
    {
        field(52100; "NTS Is Distributor"; Boolean)
        {
            Caption = 'Is Distributor';
            DataClassification = AccountData;
        }
    }
}
