//These are the resources in the IAM section of the AWS Console

//---------------------------------------------------------
// Roles
//---------------------------------------------------------

resource "aws_iam_role" "ec2webserver-role" {
  //https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role
  //Provides an IAM role.
  name = "EC2Webserver-role-tf"
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
  //https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment
  //Attaches a Managed IAM Policy to an IAM role
  role = aws_iam_role.ec2webserver-role.name
  //Grant DynamoDB Full Access
  policy_arn = "arn:aws-us-gov:iam::aws:policy/AmazonDynamoDBFullAccess"
}

resource "aws_iam_role_policy_attachment" "ssm_attachment" {
  //https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment
  //Attaches a Managed IAM Policy to an IAM role
  role = aws_iam_role.ec2webserver-role.name
  //Grant Session Manager Full Access
  policy_arn = "arn:aws-us-gov:iam::aws:policy/AmazonSSMFullAccess"
}

resource "aws_iam_instance_profile" "ec2webserver-profile" {
  //https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_instance_profile
  //Provides an IAM instance profile.
  //This is the resource used when assigning the role to the EC2
  name = "EC2_IAM_Profile-tf"
  role = aws_iam_role.ec2webserver-role.name
}