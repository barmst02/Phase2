//These are the resources in the DynamoDB section of the AWS Console

//---------------------------------------------------------
// Tables
//---------------------------------------------------------

resource "aws_dynamodb_table" "db-table-tf" {
  //https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dynamodb_table
  //Provides a DynamoDB table resource.
  name           = "simple-web-app"
  read_capacity  = 5
  write_capacity = 5
  hash_key       = "Timestamp"
  range_key      = "Comment"

  attribute {
    name = "Timestamp"
    type = "S"
  }
  attribute {
    name = "Comment"
    type = "S"
  }
}

