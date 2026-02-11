pageextension 52125 "NTS IWX License Plate" extends "IWX License Plate"
{
    layout
    {
        addafter(Shipping)
        {
            group("NTS ShipTo")
            {
                Caption = 'Ship To';
                Visible = IsShipToVisible;
                field("NTS Ship-to Name"; Rec."NTS Ship-to Name")
                {
                    ApplicationArea = all;
                }
                field("NTS Ship-to Name 2"; Rec."NTS Ship-to Name 2")
                {
                    ApplicationArea = All;
                    Caption = 'Name 2';
                    ToolTip = 'Specifies the value of the Ship-to Name 2 field.', Comment = '%';
                }
                field("NTS Ship-to Address"; Rec."NTS Ship-to Address")
                {
                    ApplicationArea = All;
                    Caption = 'Address';
                    ToolTip = 'Specifies the value of the Ship-to Address field.', Comment = '%';
                }
                field("NTS Ship-to Address 2"; Rec."NTS Ship-to Address 2")
                {
                    ApplicationArea = All;
                    Caption = 'Address 2';
                    ToolTip = 'Specifies the value of the Ship-to Address 2 field.', Comment = '%';
                }
                field("NTS Ship-to City"; Rec."NTS Ship-to City")
                {
                    ApplicationArea = All;
                    Caption = 'City';
                    ToolTip = 'Specifies the value of the Ship-to City field.', Comment = '%';
                }
                field("NTS Ship-to County"; Rec."NTS Ship-to County")
                {
                    ApplicationArea = All;
                    Caption = 'County';
                    CaptionClass = '';
                    ToolTip = 'Specifies the value of the Ship-to County field.', Comment = '%';
                }
                field("NTS Ship-to Phone No."; Rec."NTS Ship-to Phone No.")
                {
                    ApplicationArea = All;
                    Caption = 'Phone No.';
                    ToolTip = 'Specifies the value of the Ship-to Phone No. field.', Comment = '%';
                }
                field("NTS Ship-to Post Code"; Rec."NTS Ship-to Post Code")
                {
                    ApplicationArea = All;
                    Caption = 'Zip Code';
                    ToolTip = 'Specifies the value of the Ship-to Post Code field.', Comment = '%';
                }
                field("NTS Ship-to Country/Region Code"; Rec."NTS Ship-to Country/Region Code")
                {
                    ApplicationArea = All;
                    Caption = 'Country/Region';
                    ToolTip = 'Specifies the value of the Ship-to Country/Region Code field.', Comment = '%';
                }
                field("NTS Ship-to Contact"; Rec."NTS Ship-to Contact")
                {
                    ApplicationArea = All;
                    Caption = 'Contact';
                    ToolTip = 'Specifies the value of the Ship-to Contact field.', Comment = '%';
                }
            }
            group("NTS TransferFrom")
            {
                Caption = 'Transfer From';
                Visible = IsTransferFromandToVisible;
                field("NTS Transfer-from Code"; Rec."NTS Transfer-from Code")
                {
                    ApplicationArea = All;
                    Caption = 'Transfer-from Code';
                }
                field("NTS Transfer-from Name"; Rec."NTS Transfer-from Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Transfer-from Name field.', Comment = '%';
                }
                field("NTS Transfer-from Name 2"; Rec."NTS Transfer-from Name 2")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Transfer-from Name 2 field.', Comment = '%';
                }
                field("NTS Transfer-from Address"; Rec."NTS Transfer-from Address")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Transfer-from Address field.', Comment = '%';
                }
                field("NTS Transfer-from Address 2"; Rec."NTS Transfer-from Address 2")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Transfer-from Address 2 field.', Comment = '%';
                }
                field("NTS Transfer-from City"; Rec."NTS Transfer-from City")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Transfer-from City field.', Comment = '%';
                }
                field("NTS Transfer-from County"; Rec."NTS Transfer-from County")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Transfer-from County field.', Comment = '%';
                }
                field("NTS Transfer-from Post Code"; Rec."NTS Transfer-from Post Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Transfer-from Post Code field.', Comment = '%';
                }
                field("NTS Trsf.-from Country/Region Code"; Rec."NTS Trsf.-from Country/Region Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Trsf.-from Country/Region Code field.', Comment = '%';
                }
                field("NTS Transfer-from Contact"; Rec."NTS Transfer-from Contact")
                {
                    ApplicationArea = All;
                    Caption = 'Contact';
                    ToolTip = 'Specifies the name of the contact person at the location that the items are transferred from.';
                }
            }
            group("NTS TransferTo")
            {
                Caption = 'Transfer To';
                Visible = IsTransferFromandToVisible;
                field("NTS Transfer-to Name"; Rec."NTS Transfer-to Name")
                {
                    ApplicationArea = All;
                    Caption = 'Name';
                    ToolTip = 'Specifies the name of the recipient at the location that the items are transferred to.';
                }
                field("NTS Transfer-to Name 2"; Rec."NTS Transfer-to Name 2")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Transfer-to Name 2 field.', Comment = '%';
                }
                field("NTS Transfer-to Address"; Rec."NTS Transfer-to Address")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Transfer-to Address field.', Comment = '%';
                }
                field("NTS Transfer-to Address 2"; Rec."NTS Transfer-to Address 2")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Transfer-to Address 2 field.', Comment = '%';
                }
                field("NTS Transfer-to City"; Rec."NTS Transfer-to City")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Transfer-to City field.', Comment = '%';
                }
                field("NTS Transfer-to County"; Rec."NTS Transfer-to County")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Transfer-to County field.', Comment = '%';
                }
                field("NTS Transfer-to Code"; Rec."NTS Transfer-to Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Transfer-to Code field.', Comment = '%';
                }
                field("NTS Transfer-to Post Code"; Rec."NTS Transfer-to Post Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Transfer-to Post Code field.', Comment = '%';
                }
                field("NTS Trsf.-to Country/Region Code"; Rec."NTS Trsf.-to Country/Region Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Trsf.-to Country/Region Code field.', Comment = '%';
                }
                field("NTS Transfer-to Contact"; Rec."NTS Transfer-to Contact")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Transfer-to Contact field.', Comment = '%';
                }
            }

        }
    }


    trigger OnOpenPage()
    begin
        SetControlVisibility();
    end;

    trigger OnAfterGetRecord()
    begin
        SetControlVisibility();
    end;

    trigger OnAfterGetCurrRecord()
    begin
        SetControlVisibility();
    end;

    local procedure SetControlVisibility()
    begin
        clear(IsShipToVisible);
        clear(IsTransferFromandToVisible);
        IsShipToVisible := (Rec."Source Document" = Rec."Source Document"::"Sales Order") or (Rec."Shipped Source Document" = Rec."Shipped Source Document"::"Sales Order") or (Rec."Source Document" = Rec."Source Document"::"Outbound Transfer") or (Rec."Source Document" = Rec."Source Document"::"Inbound Transfer") or (Rec."Shipped Source Document" = Rec."Shipped Source Document"::"Outbound Transfer") or
            (Rec."Shipped Source Document" = Rec."Shipped Source Document"::"Inbound Transfer");

        IsTransferFromandToVisible := (Rec."Source Document" = Rec."Source Document"::"Outbound Transfer") or (Rec."Source Document" = Rec."Source Document"::"Inbound Transfer") or (Rec."Shipped Source Document" = Rec."Shipped Source Document"::"Outbound Transfer") or
            (Rec."Shipped Source Document" = Rec."Shipped Source Document"::"Inbound Transfer");
        //CurrPage.Update(false);
    end;

    var
        IsShipToVisible: Boolean;
        IsTransferFromandToVisible: Boolean;
}
