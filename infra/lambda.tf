resource "aws_iam_role" "lambda_exec_role" {
  name = "lambda_exec_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "lambda.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_policy" {
  role       = aws_iam_role.lambda_exec_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_lambda_function" "portao_handler" {
  function_name = "portao_handler"
  role          = aws_iam_role.lambda_exec_role.arn
  runtime       = "python3.9"
  handler       = "handler.lambda_handler"
  filename      = "${path.module}/../lambda/lambda_function_payload.zip"
  source_code_hash = filebase64sha256("${path.module}/../lambda/lambda_function_payload.zip")

  environment {
    variables = {
      TABELA = aws_dynamodb_table.eventos_portao.name
    }
  }
}

resource "aws_lambda_permission" "iot_invoke_lambda" {
  statement_id  = "AllowExecutionFromIoT"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.portao_handler.function_name
  principal     = "iot.amazonaws.com"
}
