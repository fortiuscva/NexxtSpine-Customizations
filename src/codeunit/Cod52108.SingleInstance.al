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

    procedure SetAssemblyLineContext(DocumentType: Enum "Assembly Document Type"; DocumentNo: Code[20]; LineNo: Integer)
    begin
        AssemblyDocumentType := DocumentType;
        AssemblyDocumentNo := DocumentNo;
        AssemblyLineNo := LineNo;
    end;

    procedure GetAssemblyLine(var DocumentType: Enum "Assembly Document Type"; var DocumentNo: Code[20]; var LineNo: Integer): Boolean
    begin
        DocumentType := AssemblyDocumentType;
        DocumentNo := AssemblyDocumentNo;
        LineNo := AssemblyLineNo;

        exit((AssemblyDocumentNo <> '') and (AssemblyLineNo <> 0));
    end;

    procedure ClearContext()
    begin
        Clear(AssemblyDocumentType);
        Clear(AssemblyDocumentNo);
        Clear(AssemblyLineNo);
    end;

    var
        AutoPostItemJnlGbl: Boolean;
        SetFromProdRoutingLinePage: Boolean;
        CalRoutings: Boolean;
        AssemblyDocumentType: Enum "Assembly Document Type";
        AssemblyDocumentNo: Code[20];
        AssemblyLineNo: Integer;
}
