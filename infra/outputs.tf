output "lambda_function_name" {
  value = aws_lambda_function.portao_handler.function_name
}

output "dynamodb_table_name" {
  value = aws_dynamodb_table.eventos_portao.name
}

output "sns_topic_arn" {
  value = aws_sns_topic.alerta_portao.arn
}
