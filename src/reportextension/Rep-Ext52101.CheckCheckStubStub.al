reportextension 52101 "NTS Check (Check/Stub/Stub)" extends "Check (Check/Stub/Stub)"
{
    RDLCLayout = './src/reportextension/Layouts/CheckCheckStubStub.rdl';
    dataset
    {
        add(PrintCheck)
        {
            column(NTSCheckAmountText; CheckAmountText)
            { }
        }
        add(PrintSettledLoop)
        {
            column(NTSPostedPurchaseInvoiceNo; PostedPurchaseInvoiceNo)
            {
            }
            column(NTSVendorInvoiceNo; VendorInvoiceNo)
            {
            }
        }
        modify(PrintSettledLoop)
        {
            trigger OnAfterAfterGetRecord()
            begin
                GetPurchaseInvoiceDetails();
            end;
        }
    }

    var
        PostedPurchaseInvoiceNo: Code[20];
        VendorInvoiceNo: Code[35];

    local procedure GetPurchaseInvoiceDetails()
    var
        PurchInvHeader: Record "Purch. Inv. Header";
        VendorLedgerEntry: Record "Vendor Ledger Entry";
    begin
        Clear(PostedPurchaseInvoiceNo);
        Clear(VendorInvoiceNo);

        // Find the vendor ledger entry for the applied invoice.
        if GenJnlLine."Applies-to Doc. No." = '' then
            exit;

        VendorLedgerEntry.Reset();
        VendorLedgerEntry.SetRange("Document No.", GenJnlLine."Applies-to Doc. No.");
        VendorLedgerEntry.SetRange("Vendor No.", GenJnlLine."Account No.");
        VendorLedgerEntry.SetRange("Document Type",
            VendorLedgerEntry."Document Type"::Invoice);

        if VendorLedgerEntry.FindFirst() then begin
            PostedPurchaseInvoiceNo := VendorLedgerEntry."Document No.";

            if PurchInvHeader.Get(PostedPurchaseInvoiceNo) then
                VendorInvoiceNo := PurchInvHeader."Vendor Invoice No.";
        end;
    end;
}