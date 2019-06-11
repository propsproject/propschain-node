resource "aws_security_group" "sidechain_sg" {
  name = "${var.environment_name}-${var.app_name}-sg"
  description = "${var.environment_name}-${var.app_name}-sg"
  vpc_id = "${var.vpc_id}"

  ingress {
    from_port = 8008
    to_port = 8008
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 4004
    to_port = 4004
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.environment_name}-${var.app_name}-sg"
    App         = "${var.app_name}"
    Environment = "${var.environment_name}"
    Service     = "Sidechain"
  }
}
