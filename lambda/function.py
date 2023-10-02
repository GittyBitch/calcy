
import json
from test_calc import calculate


#  entry point 
def lambda_handler(event, context):
    body = event.get('body')
    if body:
        requestBody = json.loads(body)
    else:
        requestBody = event
        
    x = int(requestBody.get('x', 0))
    y = int(requestBody.get('y', 0))
    
    operation = requestBody.get('operation','add')
    
    (result, status) = calculate(operation,x,y)
    
    return {
        'statusCode': status,
        'body': json.dumps(result)
    }

