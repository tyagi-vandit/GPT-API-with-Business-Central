//This codeunits contais only the procedures to send the request and fetch the response from OpenAI
//Start with defining the variables first
codeunit 50122 "GPT Management"
{

    procedure GetResponse(): Boolean
    var
        apiURL, apiKey, prompt : Text;
        bodyJson: JsonObject;
        requestHeaders: HttpHeaders;
        ResponseText: Text;
        Request: HttpRequestMessage;
        Client: HttpClient;
        Content: HttpContent;
    begin
        SetBody(Content);
        SetHeaders(Content, Request);
        Post(Content, Request, ResponseText);
        ReadResponse(ResponseText);
        exit(GlobalTextResponseValue <> '');
    end;

    local procedure SetBody(var Content: HttpContent)
    var
        bodyJson: JsonObject;
        JsonData: Text;
    begin
        bodyJson.Add('model', GetDefaultModel);
        bodyJson.Add('prompt', GlobalPrompt);
        bodyJson.Add('max_tokens', GlobalMaxToken);
        bodyJson.WriteTo(JsonData);
        Content.WriteFrom(JsonData);

    end;

    local procedure SetHeaders(var Content: HttpContent; var Request: HttpRequestMessage)
    var
        Headers: HttpHeaders;
        AuthorizationValue: Text;
    begin
        Content.GetHeaders(Headers);    //GetHeaders is predefined
        Headers.Clear();
        Headers.Add('Content-Type', 'application/json');
        Request.GetHeaders(Headers);
        Headers.Add('OpenAI-Organiztion', GlobalOrganizationID);
        AuthorizationValue := GetAuthorization(GlobalAPIKey);
        Headers.Add('Authorization', AuthorizationValue);
    end;

    local procedure Post(var Content: HttpContent; var Request: HttpRequestMessage; var ResponseText: Text)
    var
        Client: HttpClient;
        ErrorText: label 'Please Try again Later';
        ErrorResponseText: Label 'Something Wrong.Error:\ %1';
        Response: HttpResponseMessage;
    begin
        Request.Content := Content;
        Request.SetRequestUri(GetUrl);
        Request.Method := 'Post';
        if not Client.Send(Request, Response) then
            Error(ErrorText);

        Response.Content.ReadAs(ResponseText);
        if not Response.IsSuccessStatusCode()
        then
            Error(ErrorResponseText, ResponseText);

    end;


    local procedure ReadResponse(var Response: Text): Text
    var
        JsonObjResponse: JsonObject;
        JsonTokResponse: JsonToken;
        JsonTokChoices: JsonToken;
        JsonObjChoices: JsonObject;
        JsonTokTextValue: JsonToken;
        JsonArr: JsonArray;
    begin
        GlobalTextResponseValue := '*';
        JsonObjResponse.ReadFrom(Response);
        if JsonObjResponse.Get('choices', JsonTokResponse) then begin
            JsonArr := JsonTokResponse.AsArray();
            JsonArr.Get(0, JsonTokChoices);
            JsonObjChoices := JsonTokChoices.AsObject();
            JsonObjChoices.Get('text', JsonTokTextValue);
            GlobalTextResponseValue := JsonTokTextValue.AsValue().AsText();
        end;
    end;


    //Sending Request and getting response after the Authenication
    procedure SendDefaultRequest(Request: Text; var Response: Text)
    var
        OpenAISetup: Record "GPT Setup";
    begin
        OpenAISetup.Get();

        //Authentication
        SetOrganizationId(OpenAISetup."Organization ID");
        SetAPIKey(OpenAISetup."API Key");
        SetMaxToken(OpenAISetup."Default Max Token");
        SetTemperature(OpenAISetup."Default Temperature");

        //Send Request and Response
        SetPrompt(Request);
        if GetResponse() then
            Response := GetResponseTextResponseValue();
    end;



    procedure GetResponseTextResponseValue(): Text
    begin
        exit(GlobalTextResponsevalue);
    end;

    local procedure GetAuthorization(Apikey: text): Text
    begin
        exit('Bearer ' + ApiKey)
    end;

    procedure GetUrl(): Text
    begin
        exit('https://api.openai.com/v1/completions');
    end;

    //Setting the OrganizationId. It will be fetched automatically from the GPT setup table.
    procedure SetOrganizationId(OrganizationId: Text[56])
    begin
        GlobalorganizationId := OrganizationId;
    end;

    //Setting the API Key. It will be fetched automatically from the GPT setup table.
    procedure SetAPIKey(APIKey: Text)
    begin
        GlobalAPIKey := APIKey;
    end;


    // procedure SetModel(Model: Text)
    // begin
    //     GlobalModel := Model;
    // end;



    //Setting the temprature. It will be fetched automatically from the GPT setup table.
    procedure SetMaxToken(MaxToken: Integer)
    begin
        GlobalMaxToken := MaxToken;
    end;


    //Setting the temprature. It will be fetched automatically from the GPT setup table.
    procedure SetTemperature(Temperature: Decimal)
    begin

        GlobalTemperature := Temperature;
    end;


    //Setting the prompt i.e. the question you want to ask
    procedure SetPrompt(Prompt: Text)
    begin

        GlobalPrompt := Prompt;
    end;

    procedure GetDefaultModel(): Text
    begin

        //You can define model according to your preference

        //exit('text-davinci-ee3');
        exit('text-similarity-davinci-001');
    end;

    var
        GlobalOrganizationId: Text[50];
        GlobalAPIKey: Text[100];
        GlobalModel: Text[30];
        GlobalMaxToken: Integer;
        GlobalTemperature: Decimal;
        GlobalPrompt: Text;
        GlobalTextResponseValue: Text;
}