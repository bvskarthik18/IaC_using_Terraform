# Create and EC2 Instance within public subnet
resource "aws_instance" "web_server" {
  ami             = data.aws_ami.latest_amazon_linux_2.id # Amazon Linux 2 AMI
  instance_type   = "t2.micro"                            # Free tier eligible
  subnet_id             = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.ec2_sg.id] 

  tags = {
    Name = "Web_Server"
  }
}