tableextension 52142 "NTS Tracking Specification" extends "Tracking Specification"
{
    fields
    {
        modify("Lot No.")
        {
            trigger OnAfterValidate()
            begin
                ValidateLotExpiryAgainstTransferPostingDate();
            end;
        }
        modify("Expiration Date")
        {
            trigger OnAfterValidate()
            begin
                ValidateLotExpiryAgainstTransferPostingDate();
            end;
        }
    }

    procedure ValidateLotExpiryAgainstTransferPostingDate()
    var
        TransLine: Record "Transfer Line";
        TransHeader: Record "Transfer Header";
        IsSourceTypeTransfer: Boolean;
    begin
        IsSourceTypeTransfer := ("Source Type" = DATABASE::"Transfer Line");
        if not IsSourceTypeTransfer then
            exit;

        if (Rec."Lot No." = '') or (Rec."Expiration Date" = 0D) then
            exit;
        if not TransHeader.Get(Rec."Source ID") then
            exit;

        if not TransLine.Get(Rec."Source ID", Rec."Source Ref. No.") then
            exit;

        if "Expiration Date" < TransHeader."Posting Date" then
            Error(LotNoExpiredErrorLbl);
    end;

    var
        LotNoExpiredErrorLbl: Label 'Lot is Expired, choose new lot';
}
