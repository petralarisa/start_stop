# start_stop
Terraform code to start and stop EC2 instance

Note that in some version there might be a slight difference in terms of syntax.
see example below:


role = "aws_iam_role.lambda_exec_role.name" vs role = "${aws_iam_role.lambda_exec_role.name}"

So please modify accordingly.

Also, one more thing to note: certain terraform versions might cause you to encounter error for i_am_role_policy resource. If that happens to you, please try to downgrade your terraform version.

This code is written for CIT481 Senior Design - Storage Solution group.

-Petra Antyanti Larisa Anggraeni
