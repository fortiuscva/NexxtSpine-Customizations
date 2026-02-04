table 52114 "NTS OneDrive File Staging"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            AutoIncrement = true;
        }

        field(2; "File Name"; Text[250]) { }
        field(3; "File Extension"; Text[10]) { }
        field(4; "OneDrive Item Id"; Text[100]) { }
        field(5; Processed; Boolean) { }
        field(6; "Error Message"; Text[250]) { }

        field(7; "File Content"; Blob)
        {
            SubType = Memo;
        }

        field(8; "Created At"; DateTime) { }
    }

    keys
    {
        key(PK; "Entry No.") { Clustered = true; }
    }
}
