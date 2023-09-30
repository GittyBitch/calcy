resource "aws_iam_role" "lambda_role" {
  name = "lambda_role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "null_resource" "validate_python3" {
  provisioner "local-exec" {
    command = "python3 -m py_compile lambda/function.py"
  }

  triggers = {
    always_run = "${timestamp()}"
  }
}



resource "null_resource" "zip_lambda" {
  depends_on = [null_resource.validate_python3]
  provisioner "local-exec" {
    command = "zip -j lambda_function_payload.zip lambda/function.py"
  }

  triggers = {
    always_run = "${timestamp()}"
  }
}

resource "aws_lambda_function" "my_lambda" {
  function_name = "calculator_lambda"
  depends_on	= [null_resource.zip_lambda]
  handler       = "function.lambda_handler"
  runtime       = "python3.11" 
  role          = aws_iam_role.lambda_role.arn
  filename         = "lambda_function_payload.zip"
  source_code_hash = filebase64sha256("lambda_function_payload.zip")
}

resource "null_resource" "test_lambda" {
  depends_on = [aws_lambda_function.my_lambda]

  provisioner "local-exec" {
    command = "bash test_lambda.sh"
  } 
triggers = {
    always_run = "${timestamp()}"
  }
}

resource "null_resource" "check_response" {
  depends_on = [null_resource.test_lambda]

  provisioner "local-exec" {
    command = "jq '.body == \"330\"' response.json"
  } 
triggers = {
    always_run = "${timestamp()}"
  }
}


