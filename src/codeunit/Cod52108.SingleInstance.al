codeunit 52108 "NTS Single Instance"
{
    SingleInstance = true;

    procedure SetFromAutoPostItemJnl(AutoPostItemJnlPar: Boolean)
    begin
        AutoPostItemJnlGbl := AutoPostItemJnlPar;
    end;

    procedure GetFromAutoPostItemJnl(): Boolean
    begin
        exit(AutoPostItemJnlGbl);

    end;

    var
        AutoPostItemJnlGbl: Boolean;

}
