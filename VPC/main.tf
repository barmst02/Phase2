/*data "aws_vpc" "main" {
    filter {
        name = "tag:Name"
        values = ["*-tf"]
    }
}
*/

resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true

  tags = {
    Name = "phase2-tf"
  }
}