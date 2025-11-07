output "instance_ip" {
    description = "Instance Public IP"
    value = aws_instance.my_ec2.public_ip   
}

output "instance_id" {
    # description = "Instance ID"
    value = aws_instance.my_ec2.id   
}

output "instance_public_dns" {
    # description = "Public DNS"
    value = aws_instance.my_ec2.public_dns   
} 
