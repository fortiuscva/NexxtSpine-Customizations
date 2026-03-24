report 52116 "NTS Transfer Order BackOrder"
{
    ApplicationArea = All;
    Caption = 'Transfer Order BackOrder';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = './src/Reports/Layout/TOBackorderReport.rdl';
    dataset
    {
        dataitem(TransferLine; "Transfer Line")
        {
            DataItemTableView = sorting("Item No.") order(ascending)
             where("Outstanding Quantity" = filter(> 0), "NTS Backorder" = const(true));
            column(Item_No_; "Item No.")
            { }
            column(Document_No_; "Document No.")
            { }
            column(Shipment_Date; "Shipment Date")
            { }
            column(TransferFrom_Code; "Transfer-from Code")
            { }
            column(TransferTo_Code; "Transfer-to Code")
            { }
            column(Quantity_; Quantity)
            { }
            column(Outstanding_Quantity; "Outstanding Quantity")
            { }

            column(TransferFrom_Name; TransferFromName)
            { }
            column(TransferTo_Name; TransferToName)
            { }

            trigger OnAfterGetRecord()
            var
                LocationRec: Record Location;
            begin
                Clear(TransferFromName);
                Clear(TransferToName);

                if ("Transfer-from Code" <> '') and LocationRec.Get("Transfer-from Code") then
                    TransferFromName := LocationRec.Name;

                if ("Transfer-to Code" <> '') and LocationRec.Get("Transfer-to Code") then
                    TransferToName := LocationRec.Name;
            end;
        }
    }

    labels
    {
        ItemNoLbl = 'Item No.';
        TransferOrderNoLbl = 'Transfer Order No.';
        ShipmentDateLbl = 'Shipment Date';
        FromCodeLbl = 'From Code';
        FromNameLbl = 'From Name';
        ToCodeLbl = 'To Code';
        ToNameLbl = 'To Name';
        QtyLbl = 'Qty.';
        QtyOutstdLbl = 'Qty. Outstd.';
        ItemTotalLbl = 'Item %1 Total';
        ReportTitleLbl = 'Transfer Order Backorder Report';
    }

    var
        TransferFromName: Text[100];
        TransferToName: Text[100];
}
