import logging,sys,os,time
from azure.core.credentials import AzureKeyCredential
from azure.ai.formrecognizer import DocumentAnalysisClient
from authlib.integrations.requests_client import OAuth2Session
from dotenv import load_dotenv

# Acquire the logger for a library (azure.mgmt.resource in this example)
logger = logging.getLogger('azure')

# Set the desired logging level
logger.setLevel(logging.DEBUG)

handler = logging.StreamHandler(stream=sys.stdout)
logger.addHandler(handler)

load_dotenv()

client_id=os.environ.get('OIDC_CLIENT_ID')
client_secret=os.environ.get('OIDC_CLIENT_SECRET')
client_scope=os.environ.get('OIDC_CLIENT_SCOPE')
client_audience=os.environ.get('OIDC_CLIENT_AUDIENCE')
oauth2_url=os.environ.get('OIDC_URL')
ssl_verify=eval(os.environ.get('SSL_VERIFY'))
endpoint = os.environ.get('LAYOUT_ENDPOINT')

key = "myFakeKey1234"

client = OAuth2Session(client_id, client_secret, leeway=5, token_endpoint=oauth2_url, audience=client_audience, scope=client_scope, logging_enable=True, verify=ssl_verify)
token = client.fetch_token(grant_type='client_credentials', audience=client_audience)

"""
Remember to remove the key from your code when you're done, and never post it publicly. For production, use
secure methods to store and access your credentials. For more information, see 
https://docs.microsoft.com/en-us/azure/cognitive-services/cognitive-services-security?tabs=command-line%2Ccsharp#environment-variables-and-application-configuration
"""

# sample document
formUrl = "https://raw.githubusercontent.com/Azure-Samples/cognitive-services-REST-api-samples/master/curl/form-recognizer/sample-layout.pdf"

document_analysis_client = DocumentAnalysisClient(
    endpoint=endpoint, credential=AzureKeyCredential(key), logging_enable=True, connection_verify=ssl_verify
)


# Add Header for the bearer
document_analysis_client._client._config.headers_policy.add_header("Authorization", f"Bearer {token['access_token']}")

poller = document_analysis_client.begin_analyze_document_from_url("prebuilt-layout", formUrl)
result = poller.result()

for idx, style in enumerate(result.styles):
    print(
        "Document contains {} content".format(
         "handwritten" if style.is_handwritten else "no handwritten"
        )
    )

for page in result.pages:
    for line_idx, line in enumerate(page.lines):
        print(
         "...Line # {} has text content '{}'".format(
        line_idx,
        line.content.encode("utf-8")
        )
    )

    for selection_mark in page.selection_marks:
        print(
         "...Selection mark is '{}' and has a confidence of {}".format(
         selection_mark.state,
         selection_mark.confidence
         )
    )

for table_idx, table in enumerate(result.tables):
    print(
        "Table # {} has {} rows and {} columns".format(
        table_idx, table.row_count, table.column_count
        )
    )
        
    for cell in table.cells:
        print(
            "...Cell[{}][{}] has content '{}'".format(
            cell.row_index,
            cell.column_index,
            cell.content.encode("utf-8"),
            )
        )

print("----------------------------------------")
