resource "aws_dynamodb_table" "db_table" {
  name           = "simple-web-app"
  read_capacity  = 5
  write_capacity = 5
  hash_key       = "ProjectName"
  range_key      = "URL"

  attribute {
    name = "ProjectName"
    type = "S"
  }
  attribute {
    name = "URL"
    type = "S"
  }
}

