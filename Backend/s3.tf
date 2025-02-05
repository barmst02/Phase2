resource "aws_s3_bucket" "s3_backend" {
  bucket = "tf-brian-armstrong"

  tags = {
    Name = "Backend"
  }
}

