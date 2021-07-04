terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.42"
    }
  }
  required_version = ">= 0.15"
}


module "websocket" {
  source         = "./modules/websocket"
  environment    = var.environment
  webapp_api_key = var.webapp_api_key
  table_name     = var.table_name
  table_arn      = aws_dynamodb_table.examplewsstatetable.arn
}



