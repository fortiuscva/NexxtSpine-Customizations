page 52131 "NTS Serial No Lookup"
{
    PageType = List;
    SourceTable = "Item Ledger Entry";
    SourceTableTemporary = true;

    Caption = 'Available Serial Numbers';
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = All;
                }

                field("Serial No."; Rec."Serial No.")
                {
                    ApplicationArea = All;
                }

                field(Open; Rec.Open)
                {
                    ApplicationArea = All;
                }

                field("Remaining Quantity"; Rec."Remaining Quantity")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    procedure LoadTempData(var TempILE: Record "Item Ledger Entry" temporary)
    begin
        Rec.Reset();
        Rec.DeleteAll();

        if TempILE.FindSet() then
            repeat
                Rec := TempILE;
                Rec.Insert();
            until TempILE.Next() = 0;
    end;
}