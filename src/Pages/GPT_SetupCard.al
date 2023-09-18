//Table for Setup Page where the API key, Organization ID, Max Tokens, Temperature is to be entered

page 50120 "GPT SETUP"

{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "GPT Setup";
    DeleteAllowed = false;
    InsertAllowed = false;

    layout
    {
        area(Content)
        {
            group(SETUP)
            {
                Caption = 'SETUP';
                field("Organization Id"; Rec."Organization Id")
                {
                    ApplicationArea = All;

                }
                field("API Key"; Rec."API Key")
                {
                    ApplicationArea = All;
                }
                field("Default Temperature"; Rec."Default Temperature")
                {
                    ApplicationArea = All;
                }
                field("Default Max Token"; Rec."Default Max Token")
                {
                    ApplicationArea = All;
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