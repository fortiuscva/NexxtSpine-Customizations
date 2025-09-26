page 52116 "NTS Hsp. Surg. Dist. Mappings"
{
    ApplicationArea = All;
    Caption = 'Hospital-Surgeon-Distributor Mapping';
    PageType = List;
    SourceTable = "Hosp. Surg. Distrib. Mapping";
    UsageCategory = Lists;
    DataCaptionFields = Hospital, Surgeon, Distributor;

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
