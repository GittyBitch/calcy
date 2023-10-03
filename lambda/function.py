
import json
from calculator import calculate

DEFAULT_OPERATION = 'add'
DEFAULT_VALUE='1'

DEFAULT_FORMAT='DEC' # dezimal


#######################
#  entry point 
def lambda_handler(event, context):
    body = event.get('body')
    if body:
        requestBody = json.loads(body)
    else:
        requestBody = event
        
    x = int(requestBody.get('x', DEFAULT_VALUE))
    y = int(requestBody.get('y', DEFAULT_VALUE))
    
    operation = requestBody.get('operation',DEFAULT_OPERATION)
    output = requestBody.get('format', DEFAULT_FORMAT)

    (result, status) = calculate(operation,x,y)

    match output:
        case 'BIN':
            result = bin(result)
        case 'HEX':
            result = hex(result)
        case 'OCT':
            result = oct(result)
        case _:
            pass


    return {
        'statusCode': status,
        'body': json.dumps(result)
    }

