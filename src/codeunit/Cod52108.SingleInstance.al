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

    procedure SetFromProdRoutingPage(SetFromProdRoutingLinePagePar: Boolean)
    begin
        SetFromProdRoutingLinePage := SetFromProdRoutingLinePagePar;
    end;

    procedure GetFromProdRoutingPage(): Boolean
    begin
        exit(SetFromProdRoutingLinePage);

    end;

    var
        AutoPostItemJnlGbl: Boolean;
        SetFromProdRoutingLinePage: Boolean;

}
