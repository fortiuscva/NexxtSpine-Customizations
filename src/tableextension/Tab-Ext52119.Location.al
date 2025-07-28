tableextension 52119 "NTS Location" extends Location
{
    fields
    {
        field(52100; "NTS Finished Goods Location"; Boolean)
        {
            Caption = 'Finished Goods Location';
            DataClassification = ToBeClassified;


            trigger OnValidate()
            var
                LocationRec: Record Location;
            begin
                if "NTS Finished Goods Location" then begin
                    LocationRec.Reset();
                    LocationRec.SetRange("NTS Finished Goods Location", true);
                    if LocationRec.FindFirst() then
                        Error('Only one location can be marked as Finished Goods.');
                end;
            end;

        }
    }
}
