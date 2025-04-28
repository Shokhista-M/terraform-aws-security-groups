variable "vpc_id" {
  description = "The VPC ID where the security group will be created"
  type        = string
}
resource "aws_security_group" "allow_tls" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = var.vpc_id

  tags = {
    Name = "allow_tls"
  }
}


variable "ingress_rules" {
  description = "A map of ingress rules"
  type = map(object({
    cidr_ipv4   = list
    from_port   = number
    ip_protocol = string
    to_port     = number
  }))
}
resource "aws_vpc_security_group_ingress_rule" "example" {
  for_each          = var.ingress_rules
  security_group_id = aws_security_group.allow_tls.id

  cidr_ipv4   = each.value.cidr_ipv4
  from_port   = each.value.from_port
  ip_protocol = each.value.ip_protocol
  to_port     = each.value.to_port
}