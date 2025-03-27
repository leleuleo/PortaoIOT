# API Gateway + Integração com Lambda para Portão IoT com CORS (atualizado com /abrir)

resource "aws_api_gateway_rest_api" "portao_api" {
  name        = "PortaoIoTAPI"
  description = "API Gateway para acionar e consultar estado do portão"
}

resource "aws_api_gateway_resource" "estado" {
  rest_api_id = aws_api_gateway_rest_api.portao_api.id
  parent_id   = aws_api_gateway_rest_api.portao_api.root_resource_id
  path_part   = "estado"
}

resource "aws_api_gateway_resource" "fechar" {
  rest_api_id = aws_api_gateway_rest_api.portao_api.id
  parent_id   = aws_api_gateway_rest_api.portao_api.root_resource_id
  path_part   = "fechar"
}

resource "aws_api_gateway_resource" "abrir" {
  rest_api_id = aws_api_gateway_rest_api.portao_api.id
  parent_id   = aws_api_gateway_rest_api.portao_api.root_resource_id
  path_part   = "abrir"
}

resource "aws_api_gateway_method" "get_estado" {
  rest_api_id   = aws_api_gateway_rest_api.portao_api.id
  resource_id   = aws_api_gateway_resource.estado.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_method" "post_fechar" {
  rest_api_id   = aws_api_gateway_rest_api.portao_api.id
  resource_id   = aws_api_gateway_resource.fechar.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_method" "post_abrir" {
  rest_api_id   = aws_api_gateway_rest_api.portao_api.id
  resource_id   = aws_api_gateway_resource.abrir.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "get_estado_lambda" {
  rest_api_id             = aws_api_gateway_rest_api.portao_api.id
  resource_id             = aws_api_gateway_resource.estado.id
  http_method             = aws_api_gateway_method.get_estado.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.portao_handler.invoke_arn
}

resource "aws_api_gateway_integration" "post_fechar_lambda" {
  rest_api_id             = aws_api_gateway_rest_api.portao_api.id
  resource_id             = aws_api_gateway_resource.fechar.id
  http_method             = aws_api_gateway_method.post_fechar.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.portao_handler.invoke_arn
}

resource "aws_api_gateway_integration" "post_abrir_lambda" {
  rest_api_id             = aws_api_gateway_rest_api.portao_api.id
  resource_id             = aws_api_gateway_resource.abrir.id
  http_method             = aws_api_gateway_method.post_abrir.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.portao_handler.invoke_arn
}

resource "aws_lambda_permission" "apigw_invoke_lambda" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.portao_handler.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.portao_api.execution_arn}/*/*"
}

resource "aws_api_gateway_deployment" "portao_deploy" {
  depends_on = [
    aws_api_gateway_integration.get_estado_lambda,
    aws_api_gateway_integration.post_fechar_lambda,
    aws_api_gateway_integration.post_abrir_lambda
  ]

  rest_api_id = aws_api_gateway_rest_api.portao_api.id
  stage_name  = "prod"
}

output "api_gateway_url" {
  value = "https://${aws_api_gateway_rest_api.portao_api.id}.execute-api.us-east-1.amazonaws.com/prod"
}
