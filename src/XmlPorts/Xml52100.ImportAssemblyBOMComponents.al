xmlport 52100 "Import Assembly BOM Components"
{
    Caption = 'Import Assembly BOM Components';
    Direction = Import;
    Format = VariableText;
    UseRequestPage = false;

    schema
    {
        textelement(AssemblyBOM)
        {
            tableelement(Integer; Integer)
            {
                UseTemporary = true;
                AutoReplace = false;
                AutoSave = false;
                AutoUpdate = false;
                textelement(ParentItemNo) { }
                textelement(LineNo) { }
                textelement(Type) { }

                textelement(No) { }
                textelement(Description) { }
                textelement(QuantityPer) { }
                textelement(UnitOfMeasure) { }
                textelement(InstalledInItemNo) { }
                trigger OnBeforeInsertRecord()
                begin

                    BOMComponentRec.Reset();
                    BOMComponentRec.SetRange("Parent Item No.", ParentItemNo);
                    BOMComponentRec.SetRange("No.", No);
                    if BOMComponentRec.FindFirst() then
                        exit; // Skip this line if already exists

                    BOMComponentRec.Reset();
                    BOMComponentRec.SetRange("Parent Item No.", ParentItemNo);
                    if BOMComponentRec.FindLast() then
                        NextLineNo := BOMComponentRec."Line No." + 10000
                    else
                        NextLineNo := 10000;


                    BOMComponentRec.Init();
                    BOMComponentRec."Parent Item No." := ParentItemNo;
                    BOMComponentRec."Line No." := NextLineNo;
                    BOMComponentRec.Insert(true);

                    Evaluate(LineType, Type);
                    BOMComponentRec.Validate(Type, LineType);
                    BOMComponentRec.Validate("No.", No);
                    BOMComponentRec.Validate(Description, Description);
                    Evaluate(BOMComponentRec."Quantity per", QuantityPer);
                    BOMComponentRec.Validate("Unit of Measure Code", UnitOfMeasure);
                    BOMComponentRec.Validate("Installed in Item No.", InstalledInItemNo);
                    BOMComponentRec.Modify(true);
                end;

            }

        }
    }

    var
        BOMComponentRec: Record "BOM Component";
        NextLineNo: Integer;
        LineType: Enum "BOM Type";

}
