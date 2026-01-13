tableextension 52133 "NTS Prod. Order Line" extends "Prod. Order Line"
{
    fields
    {
        field(52100; "Material #1"; Code[25])
        {
            Caption = 'Material #1';
            DataClassification = ToBeClassified;
            TableRelation = "IMP Material"."IMP Code";
        }
        field(52101; "Material #2"; Code[25])
        {
            Caption = 'Material #2';
            DataClassification = ToBeClassified;
            TableRelation = "IMP Material"."IMP Code";
        }
        field(52102; "Material #3"; Code[25])
        {
            Caption = 'Material #3';
            DataClassification = ToBeClassified;
            TableRelation = "IMP Material"."IMP Code";
        }
        field(52103; "Material #4"; Code[25])
        {
            Caption = 'Material #4';
            DataClassification = ToBeClassified;
            TableRelation = "IMP Material"."IMP Code";
        }
        field(52104; "Material #5"; Code[25])
        {
            Caption = 'Material #5';
            DataClassification = ToBeClassified;
            TableRelation = "IMP Material"."IMP Code";
        }
        field(50105; "NTS Height/Depth"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Height/Depth';
            TableRelation = "IMP Height/Depth";
        }

        field(50106; "NTS System Name"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'System Name';
            TableRelation = "IMP System Name";
        }

        field(50107; "NTS Sterile Product"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Sterile Product';
            TableRelation = "IMP Sterile Product";
        }

        field(50108; "NTS IFU Number"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'IFU Number';
            TableRelation = "IMP IFU Number";
        }
        field(50109; "NTS Item Tracking Exists"; Boolean)
        {
            Caption = 'Item Tracking Exists';
            FieldClass = FlowField;
            CalcFormula = Exist("Reservation Entry" where("Source ID" = field("Prod. Order No."),
                                                                 "Source Ref. No." = const(0),
                                                                 "Source Type" = const(5406),
                                                                 "Source Subtype" = field(Status),
                                                                 "Source Batch Name" = const(''),
                                                                 "Source Prod. Order Line" = field("Line No."),
                                                                 "Reservation Status" = filter(Surplus)));
            Editable = false;
        }
        field(50110; "NTS GTIN"; Code[14])
        {
            DataClassification = ToBeClassified;
            Caption = 'GTIN';
        }
        modify("Item No.")
        {
            trigger OnAfterValidate()
            begin
                UpdateMaterialInfoForProdLineItem();
            end;
        }

    }

    procedure UpdateMaterialInfoForProdLineItem()
    begin
        if "Item No." <> '' then begin
            ItemRec.Get("Item No.");
            Rec.Validate("Material #1", ItemRec."Material #1");
            Rec.Validate("Material #2", ItemRec."Material #2");
            Rec.Validate("Material #3", ItemRec."Material #3");
            Rec.Validate("Material #4", ItemRec."Material #4");
            Rec.Validate("Material #5", ItemRec."Material #5");
            Rec.Validate("NTS Height/Depth", ItemRec."IMP Height/Depth");
            Rec.Validate("NTS System Name", ItemRec."IMP System Name");
            Rec.Validate("NTS Sterile Product", ItemRec."IMP Sterile Product");
            Rec.Validate("NTS IFU Number", ItemRec."IMP IFU Number");
            Rec.Validate("NTS GTIN", ItemRec.GTIN);
        end else begin
            Rec.Validate("Material #1", '');
            Rec.Validate("Material #2", '');
            Rec.Validate("Material #3", '');
            Rec.Validate("Material #4", '');
            Rec.Validate("Material #5", '');
            Rec.Validate("NTS Height/Depth", '');
            Rec.Validate("NTS System Name", '');
            Rec.Validate("NTS Sterile Product", '');
            Rec.Validate("NTS IFU Number", '');
            Rec.Validate("NTS GTIN", '');
        end;
    end;

    var
        ItemRec: Record Item;

}
