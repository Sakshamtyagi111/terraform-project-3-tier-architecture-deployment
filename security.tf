# Web Tier SG (Public access for ALB)
resource "aws_security_group" "vpc-web-tier-sg" {
  vpc_id = aws_vpc.vpc-3tier-demo.id
  name   = "web-tier-sg"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# App Tier SG (Only from ALB)
resource "aws_security_group" "vpc-app-tier-sg" {
  vpc_id = aws_vpc.vpc-3tier-demo.id
  name   = "app-tier-sg"

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.vpc-web-tier-sg.id]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # For your SSH troubleshooting
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# DB Tier SG (Only from App Tier)
resource "aws_security_group" "vpc-db-tier-sg" {
  vpc_id = aws_vpc.vpc-3tier-demo.id
  name   = "db-tier-sg"

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.vpc-app-tier-sg.id]
  }
}