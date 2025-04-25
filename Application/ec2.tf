resource "aws_instance" "webserver" {
  //https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance
  //Provides an EC2 instance resource. This allows instances to be created, updated, and deleted. 
  ami           = data.aws_ami.al2023.id
  instance_type = "t3.micro"

  subnet_id                   = data.aws_subnet.public-1a.id
  associate_public_ip_address = true
  user_data                   = file("user_data.sh")
  vpc_security_group_ids      = [aws_security_group.sg-ec2.id]
  iam_instance_profile        = aws_iam_instance_profile.ec2webserver-profile.id
  user_data_replace_on_change = true
  tags = {
    Name = "WebServer-tf"
  }

  //Added this to make sure the DynamoDB table is created before the EC2
  //That way the user_data.sh script can populate records in the table
  depends_on = [aws_dynamodb_table.db_table]
}


