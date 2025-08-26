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
                LocationRec.SetRange("NTS Is Finished Goods Location", true);
                if LocationRec.FindFirst() then;

                TransferHeaderRec.Reset();
                TransferHeaderRec.Init();
                TransferHeaderRec.Validate("Transfer-from Code", LocationRec.Code);
                TransferHeaderRec.Validate("Transfer-to Code", SalesHeader."Location Code");
                TransferHeaderRec.Validate("Direct Transfer", true);
                TransferHeaderRec.Insert(True);

                TransferHeaderRec.Validate("Posting Date", WorkDate());
                TransferHeaderRec.Validate("Shortcut Dimension 1 Code", SalesHeader."Shortcut Dimension 1 Code");
                TransferHeaderRec.Validate("Shortcut Dimension 2 Code", SalesHeader."Shortcut Dimension 2 Code");
                TransferHeaderRec.Validate("Assigned User ID", SalesHeader."Salesperson Code");
                TransferHeaderRec.Validate("Shipment Date", SalesHeader."Shipment Date");
                TransferHeaderRec.Validate("Shipping Agent Code", SalesHeader."Shipping Agent Code");
                TransferHeaderRec.Validate("Shipping Time", SalesHeader."Shipping Time");
                TransferHeaderRec.Validate("NTS Set Name", SalesHeader."NTS Set Name");
                TransferHeaderRec.Modify();

                SalesLineRec.SetRange("Document No.", SalesHeader."No.");
                SalesLineRec.SetRange(Type, SalesLineRec.Type::Item);
                if SalesLineRec.FindSet() then
                    repeat
                        TransferLineRec.Init();
                        TransferLineRec.Validate("Document No.", TransferHeaderRec."No.");
                        TransferLineRec.Validate("Line No.", SalesLineRec."Line No.");
                        TransferLineRec.Insert();

                        TransferLineRec.Validate("Item No.", SalesLineRec."No.");
                        TransferLineRec.Validate(Quantity, SalesLineRec.Quantity);
                        TransferLineRec.Validate("Unit of Measure", SalesLineRec."Unit of Measure");
                        TransferLineRec.Modify();
                    until SalesLineRec.Next() = 0;
            end;
        }
    }
    var
        TransferHeaderRec: Record "Transfer Header";
        TransferLineRec: Record "Transfer Line";
        SalesLineRec: Record "Sales Line";
        LocationRec: Record Location;
}
