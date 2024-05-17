tableextension 52109 "NTS G/L Entry" extends "G/L Entry"
{
    fields
    {
        field(52100; "NTS Accured Posting Month"; Code[10])
        {
            Caption = 'Accured Posting Month';
            DataClassification = ToBeClassified;
        }
        field(52101; "NTS Accured Posting Year"; Integer)
        {
            Caption = 'Accured Posting Year';
            DataClassification = ToBeClassified;
        }
    }
}
