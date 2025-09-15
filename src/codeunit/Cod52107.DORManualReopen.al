codeunit 52107 "NTS DOR Manual Reopen"
{
    TableNo = "NTS DOR Header";


    trigger OnRun()
    var
        ReleaseDorMgmnt: Codeunit "NTS DOR Release Management";
    begin
        ReleaseDorMgmnt.PerformManualReopen(Rec);
    end;

}
