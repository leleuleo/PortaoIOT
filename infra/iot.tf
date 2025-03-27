resource "aws_iot_topic_rule" "fechamento_portao" {
  name         = "FechamentoPortaoRule"
  enabled      = true
  sql          = "SELECT * FROM 'iot/portao/status'"
  sql_version  = "2016-03-23"

  lambda {
    function_arn = aws_lambda_function.portao_handler.arn
  }

  depends_on = [aws_lambda_permission.iot_invoke_lambda]
}
