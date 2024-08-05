page 52105 "NTS OneDrive Configuration"
{
    ApplicationArea = All;
    Caption = 'OneDrive Configuration';
    PageType = Card;
    SourceTable = "NTS OneDrive Configuration";
    UsageCategory = Administration;
    DeleteAllowed = false;
    InsertAllowed = false;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field("Tenant ID"; Rec."Tenant ID")
                {
                    ToolTip = 'Specifies the value of the Tenant ID field.', Comment = '%';
                }
                field("Client ID"; Rec."Client ID")
                {
                    ToolTip = 'Specifies the value of the Client ID field.', Comment = '%';
                }
                field("Client Secret"; Rec."Client Secret")
                {
                    ToolTip = 'Specifies the value of the Client Secret field.', Comment = '%';
                }
                field("OneDrive Tenant ID"; Rec."OneDrive Tenant ID")
                {
                    ToolTip = 'Specifies the value of the OneDrive Tenant ID field.', Comment = '%';
                }
                field("Source Folder Name"; Rec."Source Folder Name")
                {
                    ToolTip = 'Specifies the value of the Source Folder Name field.', Comment = '%';
                }
                field("Destination Folder Name"; Rec."Destination Folder Name")
                {
                    ToolTip = 'Specifies the value of the Destination Folder Name field.', Comment = '%';
                }
                field("File Open Path URL"; Rec."File Open Path URL")
                {
                    ToolTip = 'Specifies the value of the File Open Path URL field.', Comment = '%';
                }

            }
        }
    }
    trigger OnOpenPage()
    begin
        Rec.Reset();
        if not Rec.Get() then begin
            Rec.Init();
            Rec.Insert();
        end;
    end;
}
