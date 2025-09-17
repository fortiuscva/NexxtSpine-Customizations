codeunit 52106 "NTS DOR Release Management"
{
    TableNo = "NTS DOR Header";

    trigger OnRun()
    begin

    end;

    procedure PerformManualRelease(var DorHeader: Record "NTS DOR Header")
    begin
        // Validation check before release
        CheckForManualRelease(DorHeader);

        // Perform the actual release
        PerformManualCheckAndRelease(DorHeader);
    end;

    local procedure CheckForManualRelease(var DorHeader: Record "NTS DOR Header")
    begin
        if DorHeader.Status = DorHeader.Status::Released then
            Error('DOR document %1 is already Released.', DorHeader."No.");
    end;

    local procedure PerformManualCheckAndRelease(var DorHeader: Record "NTS DOR Header")
    begin
        if DorHeader.Status <> DorHeader.Status::Open then
            Error('Only Open DOR documents can be released. Document %1 skipped.', DorHeader."No.");

        DorHeader.Status := DorHeader.Status::Released;
        DorHeader.Modify(true);
    end;

    procedure PerformManualReopen(var DorHeader: Record "NTS DOR Header")
    begin
        // Validation before reopening
        CheckReopenStatus(DorHeader);

        // Perform the actual reopen
        Reopen(DorHeader);
    end;

    local procedure CheckReopenStatus(var DorHeader: Record "NTS DOR Header")
    begin
        if DorHeader.Status = DorHeader.Status::Open then
            Error('DOR document %1 is already Open.', DorHeader."No.");
    end;

    local procedure Reopen(var DorHeader: Record "NTS DOR Header")
    begin
        if DorHeader.Status <> DorHeader.Status::Released then
            Error('Only Released DOR documents can be reopened. Document %1 skipped.', DorHeader."No.");

        DorHeader.Status := DorHeader.Status::Open;
        DorHeader.Modify(true);
    end;


}
