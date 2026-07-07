page 52135 "NTS Serial BOM Inquiry Details"
{
    Caption = 'Serial BOM Inquiry Details';
    PageType = List;
    SourceTable = "NTS Serial BOM Inquiry Buffer";
    SourceTableTemporary = true;
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(Lines)
            {
                field("Document Type"; Rec."Document Type")
                {
                    ApplicationArea = All;
                }

                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;
                }

                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                }

                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = All;
                }

                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }

                field("Lot No."; Rec."Lot No.")
                {
                    ApplicationArea = All;
                }

                field("Serial No."; Rec."Serial No.")
                {
                    ApplicationArea = All;
                }

                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = All;
                }

                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = All;
                }

                field("Unit of Measure"; Rec."Unit of Measure")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        NexxtSpineFunctions.BuildInquiryDetails(
            FilterItemNo,
            FilterSerialNo,
            Rec);
    end;

    procedure SetParameters(
        ParentItemNo: Code[20];
        SerialNo: Code[50])
    begin
        FilterItemNo := ParentItemNo;
        FilterSerialNo := SerialNo;
    end;

    var
        NexxtSpineFunctions: Codeunit "NTS NexxtSpine Functions";
        FilterItemNo: Code[20];
        FilterSerialNo: Code[50];
}
