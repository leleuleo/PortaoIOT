resource "aws_dynamodb_table" "eventos_portao" {
  name         = "EventosPortao"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "id"

  attribute {
    name = "id"
    type = "S"
  }
}
