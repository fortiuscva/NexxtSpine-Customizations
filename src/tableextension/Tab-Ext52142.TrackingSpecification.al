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
        modify("Serial No.")
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

        if (Rec."Lot No." = '') and (Rec."Serial No." = '') and (Rec."Expiration Date" = 0D) then
            exit;
        if not TransHeader.Get(Rec."Source ID") then
            exit;

        if not TransLine.Get(Rec."Source ID", Rec."Source Ref. No.") then
            exit;

        if Rec."Expiration Date" < Today then begin
            if (Rec."Lot No." <> '') and (Rec."Serial No." <> '') then
                Error(LotorSerialExpiredErrorLbl)
            else if Rec."Serial No." <> '' then
                Error(SerialNoExpiredErrorLbl)
            else if (Rec."Lot No." <> '') then
                Error(LotNoExpiredErrorLbl);
        end;
    end;

    var
        LotNoExpiredErrorLbl: Label 'Lot is Expired, choose new lot';
        SerialNoExpiredErrorLbl: Label 'Serial is Expired, choose new serial';
        LotorSerialExpiredErrorLbl: Label 'Lot and Serial are Expired, choose new Lot and Serial';
}
