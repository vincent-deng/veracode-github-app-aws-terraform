provider "aws" {
  region = "eu-west-2"
}

#####
# VPC and subnets
#####
data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "all" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

resource "aws_ecs_cluster" "main" {
  name = "veracode-github-app-cluster"
}

resource "aws_iam_role" "ecs_task_execution_role" {
  name = "ecs_task_execution_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = { Service = "ecs-tasks.amazonaws.com" }
        Action    = "sts:AssumeRole"
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
  role       = aws_iam_role.ecs_task_execution_role.name
}

data "aws_iam_policy_document" "dynamodb_policy" {
  statement {
    effect  = "Allow"
    actions = [
      "dynamodb:BatchGetItem",
      "dynamodb:BatchWriteItem",
      "dynamodb:DeleteItem",
      "dynamodb:GetItem",
      "dynamodb:PutItem",
      "dynamodb:Query",
      "dynamodb:Scan",
      "dynamodb:UpdateItem",
    ]
    resources = ["arn:aws:dynamodb:*:*:table/veracode-github-app"]
  }
}

resource "aws_iam_role_policy" "dynamodb_policy_attachment" {
  name   = "dynamodb-policy"
  policy = data.aws_iam_policy_document.dynamodb_policy.json
  role   = aws_iam_role.ecs_task_execution_role.id
}

data "aws_iam_policy_document" "get_parameter_policy" {
  statement {
    effect  = "Allow"
    actions = [
      "ssm:GetParameters",
    ]
    resources = [
      "arn:aws:ssm:*:*:*",
      "arn:aws:ssm:*:*:*",
      "arn:aws:ssm:*:*:*"
    ]
  }
}

resource "aws_iam_role_policy" "get_paramter_policy_attachment" {
  name   = "get-parameter-policy"
  policy = data.aws_iam_policy_document.get_parameter_policy.json
  role   = aws_iam_role.ecs_task_execution_role.id
}

# ----------------- Task Definition -----------------
resource "aws_ecs_task_definition" "main" {
  family                   = "veracode-github-app-task"
  container_definitions    = jsonencode([
    {
      name  = "veracode-github-app-container"
      image = "240243041622.dkr.ecr.eu-west-2.amazonaws.com/veracode-github-app-repo:latest"
      portMappings = [
        {
          "name": "veracode-github-app-container-3000-tcp"
          containerPort = 3000
          hostPort      = 3000
          "protocol": "tcp"
        },
      ]
      "secrets": [
        {
          "name": "PRIVATE_KEY",
          "valueFrom": "arn:aws:ssm:eu-west-2:240243041622:parameter/PRIVATE_KEY"
        },
        {
          "name": "APP_ID",
          "valueFrom": "arn:aws:ssm:eu-west-2:240243041622:parameter/APP_ID"
        },
        {
          "name": "WEBHOOK_SECRET",
          "valueFrom": "arn:aws:ssm:eu-west-2:240243041622:parameter/WEBHOOK_SECRET"        }
      ],
      "logConfiguration": {
          "logDriver": "awslogs",
          "options": {
              "awslogs-group": "/ecs/veracode-github-app-task",
              "awslogs-region": "eu-west-2",
              "awslogs-stream-prefix": "ecs"
          }
      }
    },
  ])

  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  network_mode             = "awsvpc"

  execution_role_arn = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn = aws_iam_role.ecs_task_execution_role.arn
}


# ----------------- Security Groups -----------------
resource "aws_security_group" "main" {
  name_prefix = "app-sg-"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    from_port = 3000
    to_port   = 3000
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
   protocol         = "-1"
   from_port        = 0
   to_port          = 0
   cidr_blocks      = ["0.0.0.0/0"]
   ipv6_cidr_blocks = ["::/0"]
  }
}

resource "aws_security_group" "http" {
  name_prefix = "http-sg-"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
   protocol         = "-1"
   from_port        = 0
   to_port          = 0
   cidr_blocks      = ["0.0.0.0/0"]
   ipv6_cidr_blocks = ["::/0"]
  }
}

resource "aws_security_group" "https" {
  name_prefix = "https-sg-"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    from_port = 443
    to_port   = 443
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
   protocol         = "-1"
   from_port        = 0
   to_port          = 0
   cidr_blocks      = ["0.0.0.0/0"]
   ipv6_cidr_blocks = ["::/0"]
  }
}


# ----------------- Load Balancer -----------------
resource "aws_lb" "veracode_github_app_lb" {
  depends_on = [
    aws_security_group.http,
    aws_security_group.https,
  ]
  name               = "veracode-github-app-lb"
  internal           = false
  load_balancer_type = "application"
  subnets            = data.aws_subnets.all.ids

  security_groups = [aws_security_group.http.id, aws_security_group.https.id]
}

resource "aws_lb_target_group" "veracode_github_app_target_group" {
  name             = "veracode-github-app-target-group"
  port             = 3000
  protocol         = "HTTP"
  target_type      = "ip"
  vpc_id           = data.aws_vpc.default.id

  health_check {
    interval            = 30
    path                = "/probot"
    protocol            = "HTTP"
    matcher             = "200"
    timeout             = 5
    unhealthy_threshold = 2
    healthy_threshold   = 5
    port                = 3000
  }
}

resource "aws_lb_listener" "veracode_github_app_alb_listener_http" {
  depends_on = [
    aws_lb.veracode_github_app_lb,
    aws_lb_target_group.veracode_github_app_target_group,
  ]
  load_balancer_arn = aws_lb.veracode_github_app_lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.veracode_github_app_target_group.arn
  }
}


# ----------------- ECS Service -----------------
resource "aws_ecs_service" "main" {
  depends_on = [
    aws_ecs_cluster.main,
    aws_lb_target_group.veracode_github_app_target_group,
    aws_ecs_task_definition.main,
    aws_security_group.main,
    aws_lb_listener.veracode_github_app_alb_listener_http,
  ]
  name                               = "veracode-github-app-service"
  cluster                            = aws_ecs_cluster.main.id
  task_definition                    = aws_ecs_task_definition.main.arn
  deployment_minimum_healthy_percent = 50
  deployment_maximum_percent         = 200
  launch_type                        = "FARGATE" 
  desired_count                      = 2

  network_configuration {
    assign_public_ip = true
    subnets          = data.aws_subnets.all.ids
    security_groups  = [aws_security_group.main.id, aws_security_group.http.id, aws_security_group.https.id]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.veracode_github_app_target_group.arn
    container_name   = "veracode-github-app-container"
    container_port   = 3000
  }

  lifecycle {
   ignore_changes = [task_definition, desired_count]
 }
}
