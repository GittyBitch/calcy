
# Globals
HTTP_OK=200
HTTP_ERROR=501
UNSUPPORTED="Unsupported operation:"
FAKE = "FAKEIT"

def calculate(operation, x, y):
    status = HTTP_OK # HTTP Status
    match operation:
        case 'add':
            result = x + y
        case 'subtract':
            result = x - y 
        case 'pow':
            result = x ** y
        case 'mod':
            result = x%y
        case 'multiply':
            result = x * y
        case 'divide':
            if (y == 0): 
                raise ZeroDivisionError
            else:
                result = x / y
        case _:
            result =UNSUPPORTED+operation
            status=HTTP_ERROR
    return [result, status]

