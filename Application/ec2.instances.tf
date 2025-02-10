resource "aws_instance" "webserver" {

  ami           = data.aws_ami.al2023.id
  instance_type = "t3.micro"

  subnet_id                   = data.aws_subnet.public-1a.id
  associate_public_ip_address = true
  user_data                   = file("user_data.sh")
  vpc_security_group_ids      = [aws_security_group.sg-ec2.id]
  iam_instance_profile        = aws_iam_instance_profile.iam_profile.name

  tags = {
    Name = "WebServer"
  }

  depends_on = [aws_dynamodb_table.db_table]
}