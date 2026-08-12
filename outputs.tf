output "ec2_public_ip" {
    value = aws_instance.myInstance.public_ip # aws_instance.myInstance[*].public_ip, for multiple instances having same name
}

output "ec2_private_ip" {
    value = aws_instance.myInstance.private_ip
}

output "ec2_public_dns" {
    value = aws_instance.myInstance.public_dns   #connect to instance using ssh -i Terra-key-ec2 ubuntu@ec2_public_dns
}

# public dns of each instance having diff name
output "ec2_public_dns" {
    value = [
        for instance in aws_instance.myInstance : instance.public_dns
    ]
}
