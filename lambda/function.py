import json

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
    match operation:
        case 'add':
            ergebnis = x + y
        case 'subtract':
            ergebnis = x -y 
        case 'multiply':
            ergebnis = x * y
        case 'divide':
            if (y == 0): 
                ergebnis = "Division by Zero"
            else:
                ergebnis = x / y
    return {
        'statusCode': 200,
        'body': json.dumps(ergebnis)
    }

