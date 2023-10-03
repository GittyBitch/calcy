resource "aws_iam_role" "lambda_role" {
  name               = "lambda_role"
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
    command = "python -m py_compile lambda/function.py"
    on_failure  = fail # Fail if the command returns a non-zero exit code
  }

  triggers = {
    python_file_hash = filesha256("lambda/function.py")
    calculator_py_hash = filesha256("lambda/calculator.py")
    test_calc_hash = filesha256("lambda/test_calc.py")
  }

}

resource "null_resource" "run_tests" {
  provisioner "local-exec" {
    command = "cd lambda && python -m unittest test_calc.py"
    on_failure  = fail # Fail if the command returns a non-zero exit code
  }

  triggers = {
    python_file_hash = filesha256("lambda/test_calc.py")
    calculator_py_hash = filesha256("lambda/calculator.py")
  }

}


/*
resource "null_resource" "lambda_sam_local" {
  provisioner "local-exec" {
    command = "sam local invoke calculator_lambda -e test_payload.json"
  }

  triggers = {
    python_file_hash = filesha256("lambda/function.py")
  }

}
*/


# TODO: https://registry.terraform.io/providers/hashicorp/archive/latest/docs/data-sources/file
resource "null_resource" "zip_lambda" {
  depends_on = [null_resource.validate_python3, null_resource.run_tests]
  provisioner "local-exec" {
    command = "zip -j lambda_function_payload.zip lambda/*.py"
    on_failure  = fail # Fail if the command returns a non-zero exit code
  }
  triggers = {
    file_exists = fileexists("lambda_function_payload.zip")
    function_py_hash = filesha256("lambda/function.py")
    calculator_py_hash = filesha256("lambda/calculator.py")
    testcalc_py_hash = filesha256("lambda/test_calc.py")
  }
}

resource "aws_lambda_function" "my_lambda" {
  function_name = "calculator_lambda"
  depends_on    = [null_resource.zip_lambda]
  handler       = "function.lambda_handler"
  runtime       = "python3.11" # match in function.py
  role          = aws_iam_role.lambda_role.arn
  filename      = "lambda_function_payload.zip"
  #source_code_hash = filesha256("lambda_function_payload.zip")
}

resource "null_resource" "test_lambda" {
  depends_on = [aws_lambda_function.my_lambda]

  provisioner "local-exec" {
    command = "bash test_lambda.sh" # FIXME
    on_failure  = fail # Fail if the command returns a non-zero exit code
  }
  triggers = {
    source_code_hash = filesha256("lambda/function.py")
    calculator_py_hash = filesha256("lambda/calculator.py")
    test_hash = filesha256("lambda/test_calc.py")
    #always_run = "${timestamp()}"
  }
}

resource "null_resource" "check_response" {
  depends_on = [null_resource.test_lambda]

  provisioner "local-exec" {
    command = "jq '.body == \"330\"' response.json"
    on_failure  = fail # Fail if the command returns a non-zero exit code
  }
  triggers = {
    file_sha256 = filesha256("response.json")
    #always_run = "${timestamp()}"
  }
}

resource "null_resource" "check_sam_response" {
  depends_on = [null_resource.test_lambda]

  provisioner "local-exec" {
    command = "bash test_sam_local.sh"
    on_failure  = fail # Fail if the command returns a non-zero exit code
  }
  triggers = {
    #file_sha256 = filesha256("sam_response.json")
    always_run = "${timestamp()}" # FIXME
  }
}


