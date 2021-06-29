
resource "aws_dynamodb_table" "examplewsstatetable" {
  name           = var.table_name
  hash_key       = "connection_id"
  billing_mode   = "PROVISIONED"
  read_capacity  = 5
  write_capacity = 5
  attribute {
    name = "connection_id"
    type = "S"
  }
}
