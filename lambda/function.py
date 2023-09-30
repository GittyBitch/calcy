import json

# entry point
def lambda_handler(event, context):
    body = event.get('body')
    if body:
        requestBody = json.loads(body)
    else:
        requestBody = event
        
    x = int(requestBody.get('p_1', 0))
    y = int(requestBody.get('p_2', 0))
    
    operation = requestBody.get('operation','add')
    
    result = 0
    status=200
    match operation:
        case 'add':
            result = x + y
        case 'subtract':
            result = x -y 
        case 'pow':
            result = x**y
        case 'mod':
            result = x%y
        case 'multiply':
            result = x * y
        case 'divide':
            if (y == 0): 
                result = "Division by Zero"
            else:
                result = x / y
        case _:
            result ="Unsupported operation:"+operation
            status=501
    return {
        'statusCode': status,
        'body': json.dumps(result)
    }

