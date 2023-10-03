import unittest
import boto3
import json

FUNCTION_NAME = "calculator_lambda"
INVOCATION_TYPE = "RequestResponse"
EXPECTED_OUTPUT = b'{"statusCode": 200, "body": "330"}'

with open("test_payload.json", "r") as file:
    PAYLOAD = json.load(file)

class LambdaCalculatorTest(unittest.TestCase):

    def setUp(self):
        self.lambda_client = boto3.client('lambda')

    def test_lambda_function(self):
        response = self.lambda_client.invoke(
            FunctionName=FUNCTION_NAME,
            InvocationType=INVOCATION_TYPE,
            Payload=json.dumps(PAYLOAD)
        )
        result = response['Payload'].read()
        self.assertIn(EXPECTED_OUTPUT, result)

if __name__ == '__main__':
    unittest.main()

