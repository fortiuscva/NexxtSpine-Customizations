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

    procedure SetCalcRoutingsFromRefreshProdOrder(CalRoutingsPar: Boolean)
    begin
        CalRoutings := CalRoutingsPar;
    end;

    procedure GetCalcRoutingsFromRefreshProdOrder(): Boolean
    begin
        exit(CalRoutings);
    end;

    var
        AutoPostItemJnlGbl: Boolean;
        SetFromProdRoutingLinePage: Boolean;
        CalRoutings: Boolean;

}
