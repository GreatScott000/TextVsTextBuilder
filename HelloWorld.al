// Welcome to your new AL extension.
// Remember that object names and IDs should be unique across all extensions.
// AL snippets start with t*, like tpageext - give them a try and happy coding!

pageextension 50100 CustomerListExt extends "Customer List"
{
    actions
    {
        addfirst(processing)
        {
            action(Testing)
            {
                Caption = 'Run Tests';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    RunTests();
                end;
            }
        }
    }
    local procedure RunTests();
    begin
        Test(MethodType::Text);
        Test(MethodType::TextBuilder);
    end;

    local procedure Test(Method: Enum MethodType): Text
    var
        Customer: Record Customer;
        FilterBuilder: TextBuilder;
        FilterStr: Text;
        startTime: DateTime;
        endTime: DateTime;
        i: Integer;
        Result: Text;
        AddText: Text;
    begin
        startTime := CurrentDateTime();
        for i := 1 to LoopCount() do begin
            Customer.SetLoadFields("No.", Name);
            if Customer.FindSet() then begin
                repeat
                    AddText := Customer.Name;
                    case Method of
                        Method::Text:
                            begin
                                if FilterStr <> '' then
                                    FilterStr += '|';
                                FilterStr += AddText;
                            end;
                        Method::Textbuilder:
                            begin
                                FilterBuilder.Append(AddText);
                                FilterBuilder.Append('|');
                            end;
                    end;
                until Customer.Next() = 0;
            end;
        end;
        case Method of
            Method::Text:
                Result := FilterStr;
            Method::Textbuilder:
                Result := FilterBuilder.ToText().TrimEnd('|');
        end;
        endTime := CurrentDateTime();
        Message('%1\%2 Records - duration is %3\Total Length: %4', Method, LoopCount() * Customer.Count(), endTime - startTime, StrLen(Result));
    end;

    local procedure LoopCount(): Integer
    begin
        exit(250);
    end;

}

enum 50100 MethodType
{
    Extensible = true;

    value(0; TextBuilder)
    {
    }
    value(1; Text)
    {

    }
}