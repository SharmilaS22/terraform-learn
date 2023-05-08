import json

def lambda_handler(event, content):
    
    records = event["Records"]
    for record in records: 
        message = record["body"]
        print(message)

    return { 
        'statusCode': 200,
        'body': "completed"
    }