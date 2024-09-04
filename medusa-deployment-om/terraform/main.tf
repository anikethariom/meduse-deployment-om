# main.tf

provider "aws" {
  region =var.region 
}

resource "aws_vpc" "medusa_vpc" {
  cidr_block ="10.0.0.0/16"
}

resource "aws_subnet" "medusa_subnet" {
  vpc_id = aws_vpc.medusa_vpc.id
  cidr_block = "10.0.1.0/24"
}

resource "aws_security_group" "medusa_sg" {
  vpc_id = aws_vpc.medusa_vpc.id

  ingress {
    from_port = 80 
    to_port  = 80 
    protocol  = "tcp"
    cidr_block = ["0.0.0.0/0"]
   }
}

resource "aws_ecs_cluster" "medusa_cluster" {
    name = "medusa-cluster" 
}

resource "aws_ecs_tsk_defination" "medusa_task" {
    family                   = "medusa-task"
    network_mode             = "awsvpc" 
    requires_compatibilities = ["FARGATE"]
    cpu                      = "256"
    memory                   = "512" 

    container_definitions = jsonencode([ 
      {
        name      = "medusa-backend"
        image     = "medusajs/medusa"
        essential = true
        portMappings = [
          { 
             containerPort = 80
             hostPort      = 80 
          }
         ]
        }
      ])
    }

resource "aws_ecs_service" "medusa_service" {
  name            = "medusa-service"
  cluster         = aws_ecs_cluster.medusa_cluster.id
  task_defination = aws_ecs_task_definition.medusa_task.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = [aws_subnet.medusa_subnet.id]
    security_groups = [aws_security_group.medusa_sg.id]
  }

   load_balancer {
      target_group_arn = aws_lb_target_group.medusa_tg.arn
      container_name   = "medusa-backend"
      container_port   = 80
    }
  }









