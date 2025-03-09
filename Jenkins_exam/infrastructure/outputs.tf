output "vpc_id" {
  value = aws_vpc.luan_jenkins_vpc.id
}

output "subnet_id" {
  value = aws_subnet.jenkins_subnet.id
}

output "jenkins_master_public_ip" {
  value = aws_instance.jenkins_master.public_ip
}

output "jenkins_worker_public_ip" {
  value = aws_instance.jenkins_worker.public_ip
}

output "security_group_id" {
  value = aws_security_group.jenkins_sg.id
}
