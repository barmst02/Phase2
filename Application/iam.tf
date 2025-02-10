
resource "aws_iam_role" "ec2_role" {
  name = "EC2Webserver-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "dynamo_attachment" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws-us-gov:iam::aws:policy/AmazonDynamoDBFullAccess"
}

resource "aws_iam_role_policy_attachment" "ssm_attachment" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws-us-gov:iam::aws:policy/AmazonSSMFullAccess"
}

resource "aws_iam_instance_profile" "iam_profile" {
  name = "EC2_IAM_Profile"
  role = aws_iam_role.ec2_role.name
}