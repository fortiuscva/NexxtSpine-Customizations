pageextension 52108 "NTS Customer Card" extends "Customer Card"
{
    layout
    {
        addlast(General)
        {
            field("NTS Is Distributor"; Rec."NTS Distributor")
            {
                ApplicationArea = All;
            }
        }
        modify("Privacy Blocked")
        {
            Importance = Standard;
        }
        modify("Salesperson Code")
        {
            Importance = Standard;
        }
        modify("Responsibility Center")
        {
            Importance = Standard;
        }
        modify("Service Zone Code")
        {
            Importance = Standard;
        }
        modify("Document Sending Profile")
        {
            Importance = Standard;
        }
        modify(AdjProfitPct)
        {
            Importance = Standard;
        }
        modify(AdjCustProfit)
        {
            Importance = Standard;
        }
        modify("Last Date Modified")
        {
            Importance = Standard;
        }
        modify("Disable Search by Name")
        {
            Importance = Standard;
        }
        modify("IC Partner Code")
        {
            Importance = Standard;
        }
        modify("Primary Contact No.")
        {
            Importance = Standard;
        }
        modify("Fax No.")
        {
            Importance = Standard;
        }
        modify("Language Code")
        {
            Importance = Standard;
        }
        modify("Format Region")
        {
            Importance = Standard;
        }
        modify("Bill-to Customer No.")
        {
            Importance = Standard;
        }
        modify(GLN)
        {
            Importance = Standard;
        }
        modify("Gen. Bus. Posting Group")
        {
            Importance = Standard;
        }
        modify("Currency Code")
        {
            Importance = Standard;
        }
        modify("Allow Line Disc.")
        {
            Importance = Standard;
        }
        modify("Invoice Disc. Code")
        {
            Importance = Standard;
        }
        modify("Prepayment %")
        {
            Importance = Standard;
        }
        modify("Application Method")
        {
            Importance = Standard;
        }
        modify("Partner Type")
        {
            Importance = Standard;
        }
        modify("Intrastat Partner Type")
        {
            Importance = Standard;
        }
        modify("Payment Method Code")
        {
            Importance = Standard;
        }
        modify("Reminder Terms Code")
        {
            Importance = Standard;
        }
        modify("Fin. Charge Terms Code")
        {
            Importance = Standard;
        }
        modify("Cash Flow Payment Terms Code")
        {
            Importance = Standard;
        }
        modify("Print Statements")
        {
            Importance = Standard;
        }
        modify("Last Statement No.")
        {
            Importance = Standard;
        }
        modify("Block Payment Tolerance")
        {
            Importance = Standard;
        }
        modify("Preferred Bank Account Code")
        {
            Importance = Standard;
        }
        modify("Exclude from Pmt. Practices")
        {
            Importance = Standard;
        }
        modify("Shipping Agent Code")
        {
            Importance = Standard;
        }
        modify("Shipping Agent Service Code")
        {
            Importance = Standard;
        }
        modify("Shipping Time")
        {
            Importance = Standard;
        }
        modify(CustomerSince)
        {
            Importance = Standard;
        }
        modify(DaysSinceLastSale)
        {
            Importance = Standard;
        }
        modify(DistinctItemsSold)
        {
            Importance = Standard;
        }
        modify(ExpectedCustMoneyOwed)
        {
            Importance = Standard;
        }
        modify("CustomerMgt.AvgDaysToPay(""No."")")
        {
            Importance = Standard;
        }
        modify(DaysPaidPastDueDate)
        {
            Importance = Standard;
        }
        modify(PaidLateCount)
        {
            Importance = Standard;
        }
        modify(PaidOnTimeCount)
        {
            Importance = Standard;
        }
        modify(PercentPaidLate)
        {
            Importance = Standard;
        }
        modify(OverdueCount)
        {
            Importance = Standard;
        }
        modify(LastPaymentDate)
        {
            Importance = Standard;
        }
        modify(LastPaymentAmount)
        {
            Importance = Standard;
        }
        modify(LastPaymentOnTime)
        {
            Importance = Standard;
        }
        modify(InteractionCount)
        {
            Importance = Standard;
        }
        modify(LastInteractionDate)
        {
            Importance = Standard;
        }
        modify(LastInteractionType)
        {
            Importance = Standard;
        }
        modify(MostFrequentInteractionType)
        {
            Importance = Standard;
        }
    }
}