resource "aws_sns_topic" "alerta_portao" {
  name = "AlertaPortaoAberto"
}

resource "aws_sns_topic_subscription" "email_alerta" {
  topic_arn = aws_sns_topic.alerta_portao.arn
  protocol  = "email"
  endpoint  = "leonardol.rodrigues@hotmail.com.com"  # você precisará confirmar o e-mail
}
