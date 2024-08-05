report 52106 "NTS OneDrive Test"
{
    ApplicationArea = All;
    Caption = 'OneDrive Test';
    UsageCategory = ReportsAndAnalysis;
    ProcessingOnly = true;

    dataset
    {
        dataitem(Integer; "Integer")
        {
            DataItemTableView = sorting(Number) where(Number = const(1));

            trigger OnAfterGetRecord()
            var
                OneDriveIntegration: Codeunit "NTS OneDrive Integration";
                TestVar: Text;
            begin
                OneDriveIntegration.ConnectOneDriveFile('RPORD000008', 'OneDriveTest.txt', TestVar);
            end;
        }
    }
}
