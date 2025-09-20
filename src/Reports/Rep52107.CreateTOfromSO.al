report 52107 "NTS Create TO from SO"
{
    ApplicationArea = All;
    Caption = 'Create TO from SO';
    ProcessingOnly = true;
    UsageCategory = ReportsAndAnalysis;
    dataset
    {
        dataitem(SalesHeader; "Sales Header")
        {
            DataItemTableView = where("Document Type" = const(Order));
            trigger OnAfterGetRecord()
            begin
                LocationRec.Reset;
                LocationRec.SetRange("NTS Is Finished Goods Location", true);
                LocationRec.FindFirst();

                TransferHeaderRec.Init();
                TransferHeaderRec."No." := '';
                TransferHeaderRec.Insert(True);

                TransferHeaderRec.Validate("Transfer-from Code", LocationRec.Code);
                TransferHeaderRec.Validate("Transfer-to Code", SalesHeader."Location Code");
                TransferHeaderRec.Validate("Direct Transfer", true);
                TransferHeaderRec.Validate("Posting Date", WorkDate());
                TransferHeaderRec.Validate("Shortcut Dimension 1 Code", SalesHeader."Shortcut Dimension 1 Code");
                TransferHeaderRec.Validate("Shortcut Dimension 2 Code", SalesHeader."Shortcut Dimension 2 Code");
                TransferHeaderRec.Validate("Assigned User ID", SalesHeader."Salesperson Code");
                TransferHeaderRec.Validate("Shipment Date", SalesHeader."Shipment Date");
                TransferHeaderRec.Validate("Shipping Agent Code", SalesHeader."Shipping Agent Code");
                TransferHeaderRec.Validate("Shipping Time", SalesHeader."Shipping Time");
                TransferHeaderRec.Validate("NTS Set Name", SalesHeader."NTS Set Name");
                TransferHeaderRec.Validate("NTS DOR No.", SalesHeader."NTS DoR Number");
                TransferHeaderRec.Modify(true);

                NextLineNo := 10000;
                SalesLineRec.Reset();
                SalesLineRec.SetRange("Document Type", SalesHeader."Document Type");
                SalesLineRec.SetRange("Document No.", SalesHeader."No.");
                SalesLineRec.SetRange(Type, SalesLineRec.Type::Item);
                SalesLineRec.SetFilter("No.", '<>%1', '');
                if SalesLineRec.FindSet() then
                    repeat
                        TransferLineRec.Init();
                        TransferLineRec."Document No." := TransferHeaderRec."No.";
                        TransferLineRec."Line No." := NextLineNo;
                        TransferLineRec.Insert(true);

                        TransferLineRec.Validate("Item No.", SalesLineRec."No.");
                        TransferLineRec.Validate(Quantity, SalesLineRec.Quantity);
                        TransferLineRec.Validate("Unit of Measure Code", SalesLineRec."Unit of Measure Code");
                        TransferLineRec.Validate("NTS Sales Order No.", SalesLineRec."Document No.");
                        TransferLineRec.Validate("NTS Sales Order Line No.", SalesLineRec."Line No.");
                        TransferLineRec.Validate("NTS DOR No.", SalesLineRec."NTS DOR No.");
                        TransferLineRec.Validate("NTS DOR Line No.", SalesLineRec."NTS DOR Line No.");
                        TransferLineRec.Modify(true);
                        NextLineNo += 10000;
                    until SalesLineRec.Next() = 0;
            end;
        }
    }
    var
        TransferHeaderRec: Record "Transfer Header";
        TransferLineRec: Record "Transfer Line";
        SalesLineRec: Record "Sales Line";
        LocationRec: Record Location;
        NextLineNo: Integer;
}
