page 52121 "NTS Posted DOR"
{
    ApplicationArea = All;
    Caption = 'Posted DOR';
    PageType = Document;
    Editable = false;
    SourceTable = "NTS DOR Header";
    UsageCategory = None;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the number of the involved entry or record, according to the specified number series.';
                }
                field(Customer; Rec."Customer No.")
                {
                    ToolTip = 'Specifies the value of the Customer field.', Comment = '%';
                }
                field("Set Name"; Rec."Set Name")
                {
                    ToolTip = 'Specifies the value of the Set Name field.', Comment = '%';
                }
                field("Serial No."; Rec."Serial No.")
                {
                    ToolTip = 'Specifies the value of the Serial Number field.', Comment = '%';
                }
                field("Lot No."; Rec."Lot No.")
                {
                    ToolTip = 'Specifies the value of the Lot No. field.', Comment = '%';
                }
                field(Quantity; Rec.Quantity)
                {
                    ToolTip = 'Specifies the value of the Quantity field.', Comment = '%';
                }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the value of the Status field.', Comment = '%';
                }
                field(Surgeon; Rec.Surgeon)
                {
                    ToolTip = 'Specifies the value of the Surgeon field.', Comment = '%';
                }
                field(Distributor; Rec.Distributor)
                {
                    ToolTip = 'Specifies the value of the Distributor field.', Comment = '%';
                }
                field(Reps; Rec.Reps)
                {
                    ToolTip = 'Specifies the value of the Reps field.', Comment = '%';
                }
                field("Surgery Date"; Rec."Surgery Date")
                {
                    ToolTip = 'Specifies the value of the Surgery Date field.', Comment = '%';
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ToolTip = 'Specifies the value of the Posting Date field.', Comment = '%';
                }
            }
            part(PostedDoRLinesPart; "NTS Posted DOR Subform")
            {
                ApplicationArea = All;
                SubPageLink = "Document No." = field("No.");
            }

        }
    }
    actions
    {
        area(Processing)
        {
            action("NTS Sales Order")
            {
                Caption = 'Sales Order';
                ApplicationArea = all;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                trigger OnAction()
                var
                    SalesHeader: Record "Sales Header";
                begin
                    SalesHeader.Reset();
                    SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::Order);
                    SalesHeader.SetRange("NTS DoR Number", Rec."No.");
                    if SalesHeader.FindFirst() then
                        Page.RunModal(Page::"Sales Order", SalesHeader);
                end;
            }
        }
    }
}
