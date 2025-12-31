reportextension 52101 "NTS Check (Check/Stub/Stub)" extends "Check (Check/Stub/Stub)"
{
    RDLCLayout = './src/reportextension/Layouts/CheckCheckStubStub.rdl';
    dataset
    {
        add(PrintCheck)
        {
            column(NTSCheckAmountText; CheckAmountText)
            { }
        }
    }
}