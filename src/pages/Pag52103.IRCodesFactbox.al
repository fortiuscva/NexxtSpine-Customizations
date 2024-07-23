page 52103 "NTS IR Codes Factbox"
{
    ApplicationArea = All;
    Caption = 'IR Codes Factbox';
    PageType = ListPart;
    SourceTable = "NTS IR Code";
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Code"; Rec.Code)
                {
                    ApplicationArea = All;
                }
                field("IR Number"; Rec."IR Number")
                {
                    ToolTip = 'Specifies the value of the IR Number field.';
                    ApplicationArea = All;
                }
                field("IR Sheet Name"; Rec."IR Sheet Name")
                {
                    ToolTip = 'Specifies the value of the IR Sheet Name field.';
                    ApplicationArea = All;
                }
                field(Link; Rec.Link)
                {
                    ToolTip = 'Specifies the value of the Link field.';
                    ApplicationArea = All;
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(Card)
            {
                ApplicationArea = All;
                Caption = 'Card';
                Image = Card;
                RunObject = Page "NTS IR Codes";
                RunPageLink = Code = field(Code);
            }
        }
    }

    procedure InitValues(RountingNoPar: Code[20])
    begin
        RountingLines.SetRange("Routing No.", RountingNoPar);
    end;

    procedure SummarizeIRCodes()
    begin
        Rec.ClearMarks();
        RountingLines.SetCurrentKey("NTS IR Sheet 1", "NTS IR Sheet 2", "NTS IR Sheet 3");
        If RountingLines.FindSet() then
            repeat
                if RountingLines."NTS IR Sheet 1" <> '' then begin
                    if Rec.Get(RountingLines."NTS IR Sheet 1") then
                        Rec.Mark(true);
                end;
                if RountingLines."NTS IR Sheet 2" <> '' then begin
                    if Rec.Get(RountingLines."NTS IR Sheet 2") then
                        Rec.Mark(true);
                end;
                if RountingLines."NTS IR Sheet 3" <> '' then begin
                    if Rec.Get(RountingLines."NTS IR Sheet 3") then
                        Rec.Mark(true);
                end;
            until RountingLines.Next() = 0;

        Rec.MarkedOnly(true);
        if Rec.FindSet() then;
    end;

    var
        RountingLines: Record "Routing Line";
}