provider "aws" {
  region = "us-east-1"
}

resource "aws_iam_policy" "policy" {
  name = "test_policy"
  policy = <<EOF
{
  "Version" : "2012-10-17",
  "Statement" : [
    {
      "Effect" : "Allow",
      "Action" : [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource" : "arn:aws:logs:*:*:*"
    },
    {
      "Effect" : "Allow",
      "Action" : [
        "ec2:Start*",
        "ec2:Stop*"
      ],
      "Resource" : "*"
    }
  ]
}
EOF
}

resource "aws_iam_role" "lambda_exec_role" {
  name = "lambda_role"
  assume_role_policy = <<EOF
{
    "Version" : "2012-10-17",
    "Statement" : {
        "Effect" : "Allow",
        "Principal" : {"Service" : "lambda.amazonaws.com"},
        "Action" : "sts:AssumeRole"
      }
}
  EOF
}

resource "aws_iam_role_policy_attachment" "test-attach" {
  role = "aws_iam_role.lambda_exec_role.name"
  policy_arn = "aws_iam_policy.policy.arn"
}

resource "aws_lambda_function" "start_instance" {
  role = "aws_iam_role.lambda_exec_role.arn"
  #role = "arn:aws:iam::620636132257:role/lambda_role"
  handler = "start_instance.lambda_handler"
  runtime = "python3.6"
  filename = "start_instance.py.zip"
  function_name = "myStart"
}

resource "aws_lambda_function" "stop_instance" {
  role = "aws_iam_role.lambda_exec_role.arn"
  #role = "arn:aws:iam::620636132257:role/lambda_role"
  handler = "stop_instance.lambda_handler"
  runtime = "python3.6"
  filename = "stop_instance.py.zip"
  function_name = "myStop"
}

resource "aws_cloudwatch_event_rule" "cron_start" {
  name = "cron_launch"
  schedule_expression = "cron(5 20 ? * MON-FRI *)"
}

resource "aws_cloudwatch_event_rule" "cron_stop" {
  name = "cron_stop"
  schedule_expression = "cron(5 19 ? * MON-FRI *)"
}

resource "aws_cloudwatch_event_target" "run_start_lambda" {
  rule = "aws_cloudwatch_event_rule.cron_start.name"
  target_id = "aws_lambda_function.start_instance.id"
  arn = "aws_lambda_function.start_instance.arn"
}

resource "aws_cloudwatch_event_target" "run_stop_lambda" {
  rule = "aws_cloudwatch_event_rule.cron_stop.name"
  target_id = "aws_lambda_function.stop_instance.id"
  arn = "aws_lambda_function.stop_instance.arn"
}
