codeunit 52105 "NTS DOR Manual Release"
{
    TableNo = "NTS DOR Header";

    trigger OnRun()
    var
        ReleaseDorMgmnt: Codeunit "NTS DOR Release Management";
    begin
        ReleaseDorMgmnt.PerformManualRelease(Rec);
    end;

}
