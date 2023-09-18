//Table for Setup Page where the API key, Organization ID, Max Tokens, Temperature from the Page GPT_SetupCard

table 50120 "GPT Setup"
{

    DataClassification = ToBeClassified;

    fields
    {
        field(1; "PrimaryKey"; Code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(5; "Organization Id"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(10; "API Key"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(15; "Default Temperature"; Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 1;
            MaxValue = 1;
            MinValue = 0;
        }
        field(20; "Default Max Token"; Integer)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(PK1; PrimaryKey)
        {
            Clustered = true;
        }
    }



}