tableextension 52116 "NTS Transfer Line" extends "Transfer Line"
{
    fields
    {
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
