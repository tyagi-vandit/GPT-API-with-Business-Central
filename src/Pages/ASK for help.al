//Page where you will Ask the question and get the response from the ChatGPT

page 50121 "ASK FOR HELP"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    InsertAllowed = false;
    DeleteAllowed = false;
    Caption = 'ASK FOR HELP';
    //This page is not linked with any table.
    //The data is stored in the variable only.
    layout
    {
        area(Content)
        {
            group(ASK)
            {
                Caption = 'Ask here';
                //Declare variable in the end of the page else you will get the error in the name of field
                field(Question; Question)
                {
                    ApplicationArea = All;
                    Caption = 'Question';
                    MultiLine = true;
                }
            }
            group(Response)
            {
                Caption = 'Response';
                field(Answer; Answer)
                {
                    ApplicationArea = All;
                    Caption = 'Response';
                    MultiLine = true;
                    Editable = false;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(SendtoGPT)
            {
                Caption = 'Send';
                ApplicationArea = All;
                Promoted = true;
                Image = SendTo;
                PromotedIsBig = true;
                PromotedCategory = Process;


                trigger OnAction()
                var
                    GPTManagement: Codeunit "GPT Management";
                //GPT Management codeunit is in the folder CodeUnits with all the procedures defined.
                begin
                    Clear(GPTManagement);
                    GPTManagement.SendDefaultRequest(Question, Answer);
                end;
            }
        }
    }

    //Getting the REcords from API Setup
    trigger OnOpenPage()
    var
        tableGPT: Record "GPT Setup";
    begin
        tableGPT.Get();
    end;

    var
        Question: Text[400];
        Answer: Text[500];
}