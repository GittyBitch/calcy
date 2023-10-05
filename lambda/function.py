
import logging
import json
from calculator import calculate

logger = logging.getLogger()
logger.setLevel(logging.INFO)

DEFAULT_OPERATION = 'add'
DEFAULT_VALUE='1'

DEFAULT_FORMAT='DEC' # decimal

# helper function to get a variable
def getVar(event, var, default):
    body = event.get('body')
    if body:
        requestBody = json.loads(body)
    else:
        requestBody = event
    return int(requestBody.get(var, default))
    

#  entry point 
def lambda_handler(event, context):
    x = getVar(event,'y',DEFAULT_VALUE)
    y = getVar(event,'y',DEFAULT_VALUE)


    logger.info('Parameters: %s/%s', x, y)
    
    operation = getVar('operation',DEFAULT_OPERATION)
    output = getVar('format', DEFAULT_FORMAT)

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
            logger.info('Unknown Output Format requested:',operation)


    return {
        'statusCode': status,
        'body': json.dumps(result)
    }

