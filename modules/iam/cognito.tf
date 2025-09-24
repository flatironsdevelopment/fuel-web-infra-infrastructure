resource "aws_iam_user" "this" {
  name = "${var.project_name}-cognito"
}

resource "aws_iam_access_key" "this" {
  user = aws_iam_user.this.name
}

resource "aws_iam_user_policy_attachment" "this" {
  user       = aws_iam_user.this.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonCognitoPowerUser"
}


