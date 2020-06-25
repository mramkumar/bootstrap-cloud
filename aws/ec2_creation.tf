# create bastion ec2 instance
resource "aws_instance" "bastion-host" {
  key_name               = aws_key_pair.public-key.key_name
  ami                    = var.image_id
  vpc_security_group_ids = [aws_security_group.bastion-sg.id]
  subnet_id              =  aws_subnet.public-subnets["us-east-1a"].id
  instance_type          = var.bastion_instance_type
  tags = {
    Name = format("%s-%s",var.environment_name,"bastion")
  }
}

# create ec2 instances
resource "aws_instance" "worker" {
  ami           = var.image_id
  instance_type = var.ec2_instance_type
  key_name = aws_key_pair.public-key.id
  vpc_security_group_ids = [aws_security_group.private-sg.id]
  for_each = var.ec2_instances
  subnet_id = aws_subnet.private-subnets[each.value].id
  tags = {
    Name = format("%s-%s",var.environment_name,each.key)
  }
}
