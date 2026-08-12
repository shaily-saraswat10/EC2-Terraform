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
    # count = 2 , creates 2 instances having same name (meta argument)
    for_each = tomap({     # creates 2 instances having diff name (meta argument)
        Terra-01 = "t3.micro"
        Terra-02 = "t3.micro" 
    })
    key_name = aws_key_pair.myKey.key_name
    instance_type = each.value          # var.aws_instance_type (if single instance)
    vpc_security_group_ids = [aws_security_group.mySg.id]
    ami = var.ami_id
    user_data = file("install-nginx.sh")   #install the nginx after creating instance
    root_block_device {
        volume_size = var.env == "prod" ? 15 : var.root_storage_default_size    #var.root_storage_size
        volume_type = "gp3"
    }
    tags = {
        Name = each.key    #(name of instance)
    }
}