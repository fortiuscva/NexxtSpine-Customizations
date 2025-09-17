tableextension 52116 "NTS Transfer Line" extends "Transfer Line"
{
    fields
    {
        field(52100; "NTS Sales Order No."; Code[20])
        {
            Caption = 'Sales Order No.';
            DataClassification = CustomerContent;
        }
        field(52101; "NTS Sales Order Line No."; Integer)
        {
            Caption = 'Sales Order Line No.';
            DataClassification = CustomerContent;
        }
        field(52102; "NTS DOR No."; Code[20])
        {
            Caption = 'DOR No.';
            DataClassification = CustomerContent;
        }
        field(52103; "NTS DOR Line No."; Integer)
        {
            Caption = 'DOR Line No.';
            DataClassification = CustomerContent;
        }


        modify("Item No.")
        {
            trigger OnAfterValidate()
            var
                ItemRec: Record Item;
            begin
                if ItemRec.Get(Rec."Item No.") then begin
                    If ItemRec.PartStatus <> ItemRec.PartStatus::Approved then
                        Error('Item %1 Status is %2. Item status must be Approved before it can be shipped.', Rec."Item No.", ItemRec.PartStatus);
                end;
            end;
        }

    }
}
