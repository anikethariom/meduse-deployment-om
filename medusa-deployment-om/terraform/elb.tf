 # Elb. tf for Elastic Load Balancer

resource "aws_lb" "medusa_lb" {
   name               = "medusa-lb"
   internal           = false
   load_balancer_type = "application"
   security_groups    = [aws_security_group.medusa_sg.id]
   subnets            = [aws_subnet.medusa_subnet.id]
}

resource "aws_lb_target_group" "medusa_tg" {
   name     = "medusa-tg"
   port     = 9000
   protocol = "HTTP"
   vpc_id   = "aws_vpc.medusa_vpc.id"
 }

resource "aws_lb_listner" "medusa_listner" {
   load_balancer_arn = aws_lb.medusa_lb.arn 
   port              = "80"
   protocol          = "HTTP"


   default_action {
     type             = "forward"
     target_group_arn = aws_lb_target_group.medusa_tg.arn
    }
  }

resource "aws_lb_target_group_attachment" "medusa_tg_attachment" {
   target_group_arn = aws_lb_target_group.medusa_tg.arn
   target_id        = aws_ecs_service.medusa_service.id
   port             = 9000
 }

