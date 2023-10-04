
import logging
import json
from calculator import calculate

logger = logging.getLogger()
logger.setLevel(logging.INFO)

DEFAULT_OPERATION = 'add'
DEFAULT_VALUE='1'

DEFAULT_FORMAT='DEC' # dezimal

#  entry point 
def lambda_handler(event, context):
    body = event.get('body')
    if body:
        requestBody = json.loads(body)
    else:
        requestBody = event
        
    x = int(requestBody.get('x', DEFAULT_VALUE))
    y = int(requestBody.get('y', DEFAULT_VALUE))

    logger.info('Parameters: %s/%s', x, y)
    
    operation = requestBody.get('operation',DEFAULT_OPERATION)
    output = requestBody.get('format', DEFAULT_FORMAT)

    (result, status) = calculate(operation,x,y)
    logger.info('Result of %s %s %s = %s ', x, operation, y, result)

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

