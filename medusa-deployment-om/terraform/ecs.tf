# ecs.tf

resource "aws_ecs_cluster" "medusa_cluster" {
   name = "medusa-cluster"
}

resource "aws_iam_role" "ecs_task_execution_role" {
   name  = "ecsTaskExecutionRole"
   assume_role_policy = jsaonencode ({
      version = "2012-10-17",
      statement = [
         {
           Action = "sts:AssumeRole",
           Principle = {
             Service = "ecs-tasks.amazonaws.com"
           },
           Effect = "Allow", 
           Sid = ""
         }
        ]
      })
    }

resource "aws_iam_role_policy_attachment" "ecs_task_execution_policy" {
 role = aws_iam_role.ecs_task_execution_role.name
 plicy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_ecs_task_definition" "medusa_task" {
  family                   = "medusa-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode ([
   {
     name         = "medusa-backend"
     image        = "<ECR_REPOSITORY_URL>/medusa-backend:latest"
     essential    = true
     portMappings = [
       {
         containerPort = 9000
         hostPort      = 9000
         protocol      = "tcp "
       }
      ]
     environment = [
       { 
         name   = "DATABASE_URL"
         value  = "<RDS_DATABASE_URL>"
       },
       {
         name  = "JWT_SECRET"
         value = "supersecretjwt"
       },
       {
         name  = "COOKIE_SECRET"
         value = "supersecretcookie"
       }
      ]
     }
    ])
   }

resource "aws_ecs_service" "medusa_service" {
  name            = "medusa-service"
  cluster         = aws_ecs_cluster.medusa_cluster.id
  task_definition = aws_ecs_task_definition.medusa_task.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
     subnets         = [aws_subnet.medusa_subnet.id]
     security_groups = [aws_security_group.medusa_sg.id]
    }
  } 










