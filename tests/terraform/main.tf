terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.42"
    }
  }
  required_version = ">= 0.15"
}




module "examplews" {
  source      = "./modules/examplews"
  environment = var.environment
  table_name  = var.table_name
  table_arn   = aws_dynamodb_table.examplewsstatetable.arn
}



