resource "aws_apigatewayv2_api" "http_api" {
  depends_on    = [aws_s3_bucket.my_bucket]
  name          = "my-http-api"
  protocol_type = "HTTP"

  cors_configuration {
    allow_headers = ["content-type", "x-amz-date", "authorization", "x-api-key", "x-amz-security-token", "x-amz-user-agent"]
    allow_methods = ["GET", "POST", "OPTIONS"]
    allow_origins = ["http://${aws_s3_bucket_website_configuration.my_website.website_endpoint}"] # FIXME 
    max_age       = 300
  }
}

resource "aws_apigatewayv2_integration" "lambda_integration" {
  api_id           = aws_apigatewayv2_api.http_api.id
  integration_type = "AWS_PROXY"
  integration_uri  = aws_lambda_function.my_lambda.invoke_arn
}

resource "aws_lambda_permission" "invoke" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.my_lambda.arn
  principal     = "apigateway.amazonaws.com"
}

resource "aws_apigatewayv2_route" "example_route" {
  api_id    = aws_apigatewayv2_api.http_api.id
  route_key = "POST /calc"
  target    = "integrations/${aws_apigatewayv2_integration.lambda_integration.id}"
}

resource "aws_apigatewayv2_deployment" "example_deployment" {
  api_id      = aws_apigatewayv2_api.http_api.id
  description = "Example deployment"

  depends_on = [
    aws_apigatewayv2_route.example_route,
    aws_apigatewayv2_integration.lambda_integration
  ]
}

resource "aws_apigatewayv2_stage" "example_stage" {
  api_id        = aws_apigatewayv2_api.http_api.id
  auto_deploy   = false
  name          = "$default"
  deployment_id = aws_apigatewayv2_deployment.example_deployment.id
}

resource "null_resource" "test_endpoint" { # patch
  depends_on = [aws_apigatewayv2_stage.example_stage]
  provisioner "local-exec" {
    command = "bash test_api_gateway.sh ${aws_apigatewayv2_api.http_api.api_endpoint}"
  } # TODO: fail

  triggers = {
    endpoint_url = aws_apigatewayv2_api.http_api.api_endpoint
    file_sha256 = filesha256("lambda_function_payload.zip")
    api_gateway_id = "${aws_apigatewayv2_api.http_api.id}"
    #always_run = "${timestamp()}"
  }
}


output "http_api_url" {
  value = aws_apigatewayv2_api.http_api.api_endpoint
}

