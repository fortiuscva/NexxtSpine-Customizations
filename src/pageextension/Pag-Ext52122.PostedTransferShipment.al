pageextension 52122 "NTS Posted Transfer Shipment" extends "Posted Transfer Shipment"
{
    layout
    {
        addafter(Shipment)
        {
            group("NTS ShipTo")
            {
                Caption = 'Ship-To';

                field("NTS Customer Code"; Rec."NTS Customer Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Customer Code field.', Comment = '%';
                    Editable = false;
                }
                field("NTS Ship-to Code"; Rec."NTS Ship-to Code")
                {
                    ApplicationArea = All;
                    Caption = 'Code';
                    ToolTip = 'Specifies the value of the Ship-to Code field.', Comment = '%';
                    Editable = false;
                }
                field("NTS Ship-to Name"; Rec."NTS Ship-to Name")
                {
                    ApplicationArea = All;
                    Caption = 'Name';
                    ToolTip = 'Specifies the value of the Ship-to Name field.', Comment = '%';
                    Editable = false;
                }
                field("NTS Ship-to Name 2"; Rec."NTS Ship-to Name 2")
                {
                    ApplicationArea = All;
                    Caption = 'Name 2';
                    ToolTip = 'Specifies the value of the Ship-to Name 2 field.', Comment = '%';
                    Editable = false;
                }
                field("NTS Ship-to Address"; Rec."NTS Ship-to Address")
                {
                    ApplicationArea = All;
                    Caption = 'Address';
                    ToolTip = 'Specifies the value of the Ship-to Address field.', Comment = '%';
                    Editable = false;
                }
                field("NTS Ship-to Address 2"; Rec."NTS Ship-to Address 2")
                {
                    ApplicationArea = All;
                    Caption = 'Address 2';
                    ToolTip = 'Specifies the value of the Ship-to Address 2 field.', Comment = '%';
                    Editable = false;
                }
                field("NTS Ship-to City"; Rec."NTS Ship-to City")
                {
                    ApplicationArea = All;
                    Caption = 'City';
                    ToolTip = 'Specifies the value of the Ship-to City field.', Comment = '%';
                    Editable = false;
                }
                field("NTS Ship-to County"; Rec."NTS Ship-to County")
                {
                    ApplicationArea = All;
                    Caption = 'County';
                    CaptionClass = '';
                    ToolTip = 'Specifies the value of the Ship-to County field.', Comment = '%';
                    Editable = false;
                }
                field("NTS Ship-to Phone No."; Rec."NTS Ship-to Phone No.")
                {
                    ApplicationArea = All;
                    Caption = 'Phone No.';
                    ToolTip = 'Specifies the value of the Ship-to Phone No. field.', Comment = '%';
                    Editable = false;
                }
                field("NTS Ship-to Post Code"; Rec."NTS Ship-to Post Code")
                {
                    ApplicationArea = All;
                    Caption = 'Zip Code';
                    ToolTip = 'Specifies the value of the Ship-to Post Code field.', Comment = '%';
                    Editable = false;
                }
                field("NTS Ship-to Country/Region Code"; Rec."NTS Ship-to Country/Region Code")
                {
                    ApplicationArea = All;
                    Caption = 'Country/Region';
                    ToolTip = 'Specifies the value of the Ship-to Country/Region Code field.', Comment = '%';
                    Editable = false;
                }
                field("NTS Ship-to Contact"; Rec."NTS Ship-to Contact")
                {
                    ApplicationArea = All;
                    Caption = 'Contact';
                    ToolTip = 'Specifies the value of the Ship-to Contact field.', Comment = '%';
                    Editable = false;
                }
            }
        }
        addlast(General)
        {
            field("NTS Work Description"; Rec.GetWorkDescription())
            {
                ApplicationArea = All;
                MultiLine = true;
                Editable = false;
                ToolTip = 'Specifies the value of the Work Description field.', Comment = '%';
            }
        }
    }
    actions
    {
        addafter("&Print")
        {
            action("NTS Transfer Shipment PL")
            {
                ApplicationArea = all;
                Caption = 'Packing List';
                Image = Report;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                trigger OnAction()
                var
                    TransferShipmentHeader: Record "Transfer Shipment Header";
                begin
                    CurrPage.SetSelectionFilter(TransferShipmentHeader);
                    Report.RunModal(Report::"NTS Transfer Shipment PL", true, false, TransferShipmentHeader)
                end;
            }
        }
    }
}
