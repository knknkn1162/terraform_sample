import json
import boto3
import datetime
import os

translate = boto3.client(service_name='translate')

table_name = os.environ['TABLENAME']
dynamodb_translate_history_tbl = boto3.resource('dynamodb').Table(table_name)

def lambda_handler(event, context):

    input_text = event['inputText']

    response = translate.translate_text(
        Text=input_text,
        SourceLanguageCode="ja",
        TargetLanguageCode="en"
    )

    output_text = response.get('TranslatedText')

    dynamodb_translate_history_tbl.put_item(
      Item = {
        "timestamp": datetime.datetime.now().strftime("%Y%m%d%H%M%S"),
        "inputText": input_text,
        "outputText": output_text
      }
    )

    return {
        'statusCode': 200,
        'body': json.dumps({
            'output_text': output_text
        }),
        'isBase64Encoded': False,
        'headers': {}
    }