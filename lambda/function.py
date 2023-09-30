import json

# new entry point
def lambda_handler(event, context):
    body = event.get('body')
    if body:
        requestBody = json.loads(body)
    else:
        requestBody = event
        
    x = int(requestBody.get('p_1', 0))
    y = int(requestBody.get('p_2', 0))
    
    operation = requestBody.get('operation','add')
    
    ergebnis = 0
    status=200
    match operation:
        case 'add':
            ergebnis = x + y
        case 'subtract':
            ergebnis = x -y 
        case 'pow':
            ergebnis = x**y
        case 'mod':
            ergebnis = x%y
        case 'multiply':
            ergebnis = x * y
        case 'divide':
            if (y == 0): 
                ergebnis = "Division by Zero"
            else:
                ergebnis = x / y
        case _:
            ergebnis ="Unsupported operation:"+operation
            status=501
    return {
        'statusCode': status,
        'body': json.dumps(ergebnis)
    }

