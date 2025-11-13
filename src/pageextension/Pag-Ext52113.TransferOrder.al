pageextension 52113 "NTS Transfer Order" extends "Transfer Order"
{
    layout
    {
        addlast(shipment)
        {
            field("NTS Tracking No."; Rec."NTS Tracking No.")
            {
                ApplicationArea = all;
            }
            field("NTS Tracking URL"; Rec."NTS Tracking URL")
            {
                ApplicationArea = all;
            }
        }
        addafter(Shipment)
        {
            group("NTS ShipTo")
            {
                Caption = 'Ship-To';

                field("NTS Customer Code"; Rec."NTS Customer Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Customer Code field.', Comment = '%';
                }
                field("NTS Ship-to Code"; Rec."NTS Ship-to Code")
                {
                    ApplicationArea = All;
                    Caption = 'Code';
                    ToolTip = 'Specifies the value of the Ship-to Code field.', Comment = '%';
                }
                field("NTS Ship-to Name"; Rec."NTS Ship-to Name")
                {
                    ApplicationArea = All;
                    Caption = 'Name';
                    ToolTip = 'Specifies the value of the Ship-to Name field.', Comment = '%';
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
                    Caption = 'Post Code';
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
        }
    }
}
