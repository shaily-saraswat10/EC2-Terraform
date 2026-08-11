# Key pair
resource "aws_key_pair" "myKey" {
    key_name = "Terra-Key-ec2"
    public_key = file("Terra-Key-ec2.pub")
}

# VPC & security group
resource "aws_default_vpc" "default" {

}

resource "aws_security_group" "mySg" {
    name = "TerraSg"
    description = "security group for terra"
    vpc_id = aws_default_vpc.default.id   #interpolation
    # inbound rules
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        description = "SSH open"
    }
    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        description = "HTTP open"
    }

    # outbound rules
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
        description = "open for all"
    }

    tags = {
        Name = "TerraSg"
    }
}

# EC2
resource "aws_instance" "myInstance" {
    key_name = aws_key_pair.myKey.key_name
    instance_type = var.aws_instance_type
    vpc_security_group_ids = [aws_security_group.mySg.id]
    ami = var.ami_id
    root_block_device {
        volume_size = var.root_storage_size
        volume_type = "gp3"
    }
    tags = {
        Name = "Terra-ec2"
    }
}