tableextension 52113 "NTS Sales Line" extends "Sales Line"
{
    fields
    {
        modify("No.")
        {
            trigger OnAfterValidate()
            var
                ItemRec: Record Item;
            begin
                if not (Rec.Type = Type::Item) then
                    exit;
                if ItemRec.Get(Rec."No.") then begin
                    case ItemRec.PartStatus of
                        ItemRec.PartStatus::Released:
                            Error('Item %1 Status is Released. Item status must be Approved before it can be shipped.', Rec."No.");
                        ItemRec.PartStatus::Obsolete:
                            Error('Item %1 Status is Obsolete. Obsolete Items cannot be shipped.', Rec."No.");
                    end;
                end;
            end;
        }
    }
}
