tableextension 52113 "NTS Sales Line" extends "Sales Line"
{
    fields
    {
        modify("No.")
        {
            trigger OnBeforeValidate()
            var
                ItemRec: Record Item;
            begin
                if ItemRec.Get(Rec."No.") then begin
                    if ItemRec.PartStatus = ItemRec.PartStatus::Released then begin
                        Error('Item %1 Status is Released. Item status must be Approved before it can be shipped.', Rec."No.");
                    end;
                    if ItemRec.PartStatus = ItemRec.PartStatus::Obsolete then
                        Error('Item %1 Status is Obsolete. Obsolete Items cannot be shipped.', Rec."No.");
                end;
            end;
        }
    }
}
