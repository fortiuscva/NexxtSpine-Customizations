page 52116 "NTS Hosp.Surg.Distrib. Mapping"
{
    ApplicationArea = All;
    Caption = 'Hospital-Surgeon-Distributor Mapping';
    PageType = List;
    SourceTable = "Hosp. Surg. Distrib. Mapping";
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(Hospital; Rec.Hospital)
                {
                    ToolTip = 'Specifies the value of the Hospital field.', Comment = '%';
                }
                field(Surgeon; Rec.Surgeon)
                {
                    ToolTip = 'Specifies the value of the Surgeon field.', Comment = '%';
                }
                field(Distributor; Rec.Distributor)
                {
                    ToolTip = 'Specifies the value of the Distributor field.', Comment = '%';
                }
            }
        }
    }
}
