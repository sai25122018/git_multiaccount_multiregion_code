#Terraform Block
terraform {
	required_version = "~> 1.3.2"
	required_providers {
		aws = {
			source = "hashicorp/aws"
			version = "~> 4.34.0"
		}
	}
}
#Provider Block
provider "aws" {
	region = "us-east-1"
	profile = "default"
}
provider "aws" {
	region = "us-east-2" 
	profile = "default"
	alias = "aws-east-2"
}
provider "aws" {
	region = "us-west-1"
	profile = "default"
	alias = "aws-west-1"
	assume_role {
		role_arn = "arn:aws:iam::345630149727:role/Admin_Role"
	}
}
#Data Source Block
data "aws_ami" "amzlinux1" {
	most_recent = true
	owners = [ "amazon" ]
filter {
	name = "name"
	values = [ "amzn2-ami-hvm-*" ]
}
filter {
	name = "root-device-type"
	values = [ "ebs" ]
}
filter {
	name = "virtualization-type"
	values = [ "hvm" ]
}
filter {
	name = "architecture"
	values = [ "x86_64" ]
}
}
#Data Source Block
data "aws_ami" "amzlinux2" {
	most_recent = true
	provider = aws.aws-east-2
	owners = [ "amazon" ]
filter {
	name = "name"
	values = [ "amzn2-ami-hvm-*" ]
}
filter {
	name = "root-device-type"
	values = [ "ebs" ]
}
filter {
	name = "virtualization-type"
	values = [ "hvm" ]
}
filter {
	name = "architecture"
	values = [ "x86_64" ]
}
}
#Data Source Block
data "aws_ami" "amzlinux3" {
	most_recent = true
	provider = aws.aws-west-1
	owners = [ "amazon" ]
filter {
	name = "name"
	values = [ "amzn2-ami-hvm-*" ]
}
filter {
	name = "root-device-type"
	values = [ "ebs" ]
}
filter {
	name = "virtualization-type"
	values = [ "hvm" ]
}
filter {
	name = "architecture"
	values = [ "x86_64" ]
}
}
#Resource Block-vpc
resource "aws_vpc" "aws-vpc-east-1" {
	cidr_block = "10.1.0.0/16"
	tags = {
		Name = "aws-vpc-east-1-${terraform.workspace}"
	}
}
resource "aws_vpc" "aws-vpc-east-2" {
	cidr_block = "192.168.0.0/16"
	provider = aws.aws-east-2
	tags = {
		Name = "aws-vpc-east-2-${terraform.workspace}"
	}
}
resource "aws_vpc" "aws-vpc-west-1" {
	cidr_block = "172.16.0.0/16"
	provider = aws.aws-west-1
	tags = {
		Name = "aws-vpc-west-1-${terraform.workspace}"
	}
}
#Resource Block-Subnets
resource "aws_subnet" "aws-subnet1-east-1" {
	vpc_id = aws_vpc.aws-vpc-east-1.id
	cidr_block = "10.1.1.0/24"
	availability_zone = "us-east-1a"
	map_public_ip_on_launch = true
	tags = {
		Name = "aws-subnet1-east-1-${terraform.workspace}"
	}
}
resource "aws_subnet" "aws-subnet2-east-1" {
	vpc_id = aws_vpc.aws-vpc-east-1.id
	cidr_block = "10.1.2.0/24"
	availability_zone = "us-east-1b"
	map_public_ip_on_launch = true
	tags = {
		Name = "aws-subnet2-east-1-${terraform.workspace}"
	}
}
resource "aws_subnet" "aws-subnet3-east-1" {
	vpc_id = aws_vpc.aws-vpc-east-1.id
	cidr_block = "10.1.3.0/24"
	availability_zone = "us-east-1c"
	map_public_ip_on_launch = true
	tags = {
		Name = "aws-subnet3-east-1-${terraform.workspace}"
	}
}
resource "aws_subnet" "aws-subnet1-east-2" {
	vpc_id = aws_vpc.aws-vpc-east-2.id
	cidr_block = "192.168.1.0/24"
	provider = aws.aws-east-2
	availability_zone = "us-east-2a"
	map_public_ip_on_launch = true
	tags = {
		Name = "aws-subnet1-east-2-${terraform.workspace}"
	}
}
resource "aws_subnet" "aws-subnet2-east-2" {
	vpc_id = aws_vpc.aws-vpc-east-2.id
	cidr_block = "192.168.2.0/24"
	provider = aws.aws-east-2
	availability_zone = "us-east-2b"
	map_public_ip_on_launch = true
	tags = {
		Name = "aws-subnet2-east-2-${terraform.workspace}"
	}
}
resource "aws_subnet" "aws-subnet3-east-2" {
	vpc_id = aws_vpc.aws-vpc-east-2.id
	cidr_block = "192.168.3.0/24"
	provider = aws.aws-east-2
	availability_zone = "us-east-2c"
	map_public_ip_on_launch = true
	tags = {
		Name = "aws-subnet3-east-2-${terraform.workspace}"
	}
}
resource "aws_subnet" "aws-subnet1-west-1" {
	vpc_id = aws_vpc.aws-vpc-west-1.id
	cidr_block = "172.16.1.0/24"
	provider = aws.aws-west-1
	availability_zone = "us-west-1a"
	map_public_ip_on_launch = true
	tags = {
		Name = "aws-subnet1-west-1-${terraform.workspace}"
	}
}
resource "aws_subnet" "aws-subnet2-west-1" {
	vpc_id = aws_vpc.aws-vpc-west-1.id
	cidr_block = "172.16.2.0/24"
	provider = aws.aws-west-1
	availability_zone = "us-west-1b"
	map_public_ip_on_launch = true
	tags = {
		Name = "aws-subnet2-west-1-${terraform.workspace}"
	}
} 
#Resource Block- Internet_gateway
resource "aws_internet_gateway" "aws-IGW-east-1" {
	vpc_id = aws_vpc.aws-vpc-east-1.id
	tags = {
		Name = "aws-IGW-east-1-${terraform.workspace}"
	}
}
resource "aws_internet_gateway" "aws-IGW-east-2" {
	vpc_id = aws_vpc.aws-vpc-east-2.id
	provider = aws.aws-east-2
	tags = {
		Name = "aws-IGW-east-2-${terraform.workspace}"
	}
}
resource "aws_internet_gateway" "aws-IGW-west-1" {
	vpc_id = aws_vpc.aws-vpc-west-1.id
	provider = aws.aws-west-1
	tags = {
		Name = "aws-IGW-west-1-${terraform.workspace}"
	}
}
#Resource Block -RouteTables
resource "aws_route_table" "aws-Main-RT-east-1" {
	vpc_id = aws_vpc.aws-vpc-east-1.id
	tags = {
		Name = "aws-Main-RT-east-1-${terraform.workspace}"
	}
}
resource "aws_route_table" "aws-Main-RT-east-2" {
	vpc_id = aws_vpc.aws-vpc-east-2.id
	provider = aws.aws-east-2
	tags = {
		Name = "aws-Main-RT-east-2-${terraform.workspace}"
	}
}
resource "aws_route_table" "aws-Main-RT-west-1" {
	vpc_id = aws_vpc.aws-vpc-west-1.id
	provider = aws.aws-west-1
	tags = {
		Name = "aws-Main-RT-west-1-${terraform.workspace}"
	}
}
#Resource Block-Internet Access provding through Route table
resource "aws_route" "aws-route-east-1" {
	route_table_id = aws_route_table.aws-Main-RT-east-1.id
	gateway_id = aws_internet_gateway.aws-IGW-east-1.id
	destination_cidr_block = "0.0.0.0/0"
}
resource "aws_route" "aws-route-east-2" {
	route_table_id = aws_route_table.aws-Main-RT-east-2.id
	provider = aws.aws-east-2
	gateway_id = aws_internet_gateway.aws-IGW-east-2.id
	destination_cidr_block = "0.0.0.0/0"
}
resource "aws_route" "aws-route-west-1" {
	route_table_id = aws_route_table.aws-Main-RT-west-1.id
	provider = aws.aws-west-1
	gateway_id = aws_internet_gateway.aws-IGW-west-1.id
	destination_cidr_block = "0.0.0.0/0"
}
#Resource Block-Subnets_Association
resource "aws_route_table_association" "aws_subnet1-east-1a-association" {
	route_table_id = aws_route_table.aws-Main-RT-east-1.id
	subnet_id = aws_subnet.aws-subnet1-east-1.id
}
resource "aws_route_table_association" "aws_subnet2-east-1b-association" {
	route_table_id = aws_route_table.aws-Main-RT-east-1.id
	subnet_id = aws_subnet.aws-subnet2-east-1.id
}
resource "aws_route_table_association" "aws_subnet3-east-1c-association" {
	route_table_id = aws_route_table.aws-Main-RT-east-1.id
	subnet_id = aws_subnet.aws-subnet3-east-1.id
}
resource "aws_route_table_association" "aws_subnet1-east-2a-association" {
	route_table_id = aws_route_table.aws-Main-RT-east-2.id
	provider = aws.aws-east-2
	subnet_id = aws_subnet.aws-subnet1-east-2.id
}
resource "aws_route_table_association" "aws_subnet2-east-2b-association" {
	route_table_id = aws_route_table.aws-Main-RT-east-2.id
	provider = aws.aws-east-2
	subnet_id = aws_subnet.aws-subnet2-east-2.id
}
resource "aws_route_table_association" "aws_subnet3-east-2c-association" {
	route_table_id = aws_route_table.aws-Main-RT-east-2.id
	provider = aws.aws-east-2
	subnet_id = aws_subnet.aws-subnet3-east-2.id
}
resource "aws_route_table_association" "aws_subnet1-west-1a-association" {
	route_table_id = aws_route_table.aws-Main-RT-west-1.id
	provider = aws.aws-west-1
	subnet_id = aws_subnet.aws-subnet1-west-1.id
}
resource "aws_route_table_association" "aws_subnet1-west-1b-association" {
	route_table_id = aws_route_table.aws-Main-RT-west-1.id
	provider = aws.aws-west-1
	subnet_id = aws_subnet.aws-subnet2-west-1.id
}
#Resource Block-Security_Group
resource "aws_security_group" "aws-SG-east-1-ssh" {
	description = "aws-SG-east-1-ssh"
	name = "aws-SG-east-1-ssh-${terraform.workspace}"
	vpc_id = aws_vpc.aws-vpc-east-1.id
	tags = {
		Name = "aws-SG-east-1-ssh-${terraform.workspace}"
}
ingress {
	description = "Allow Port 22"
	from_port = 22
	to_port = 22
	protocol = "tcp"
	cidr_blocks = [ "0.0.0.0/0" ]
}
egress {
	description = "Allow all ports and ips"
	from_port = 0
	to_port = 0
	protocol = "-1"
	cidr_blocks = [ "0.0.0.0/0" ]
}
}
resource "aws_security_group" "aws-SG-east-1-web" {
	description = "aws-SG-east-1-web"
	name = "aws-SG-east-1-web-${terraform.workspace}"
	vpc_id = aws_vpc.aws-vpc-east-1.id
	tags = {
		Name = "aws-SG-east-1-web-${terraform.workspace}"
}
ingress {
	description = "Allow Port 443"
	from_port = 443
	to_port = 443
	protocol = "tcp"
	cidr_blocks = [ "0.0.0.0/0" ]
}
ingress {
	description = "Allow Port 80"
	from_port = 80
	to_port = 80
	protocol = "tcp"
	cidr_blocks = [ "0.0.0.0/0" ]
}
egress {
	description = "Allow all ports and ips"
	from_port = 0
	to_port = 0
	protocol = "-1"
	cidr_blocks = [ "0.0.0.0/0" ]
}
}
resource "aws_security_group" "aws-SG-east-2-ssh" {
	description = "aws-SG-east-2-ssh"
	provider = aws.aws-east-2
	name = "aws-SG-east-2-ssh-${terraform.workspace}"
	vpc_id = aws_vpc.aws-vpc-east-2.id
	tags = {
		Name = "aws-SG-east-2-ssh-${terraform.workspace}"
}
ingress {
	description = "Allow Port 22"
	from_port = 22
	to_port = 22
	protocol = "tcp"
	cidr_blocks = [ "0.0.0.0/0" ]
}
egress {
	description = "Allow all ports and ips"
	from_port = 0
	to_port = 0
	protocol = "-1"
	cidr_blocks = [ "0.0.0.0/0" ]
}
}
resource "aws_security_group" "aws-SG-east-2-web" {
	description = "aws-SG-east-2-web"
	provider = aws.aws-east-2
	name = "aws-SG-east-2-web-${terraform.workspace}"
	vpc_id = aws_vpc.aws-vpc-east-2.id
	tags = {
		Name = "aws-SG-east-2-web-${terraform.workspace}"
}
ingress {
	description = "Allow Port 443"
	from_port = 443
	to_port = 443
	protocol = "tcp"
	cidr_blocks = [ "0.0.0.0/0" ]
}
ingress {
	description = "Allow Port 80"
	from_port = 80
	to_port = 80
	protocol = "tcp"
	cidr_blocks = [ "0.0.0.0/0" ]
}
egress {
	description = "Allow all ports and ips"
	from_port = 0
	to_port = 0
	protocol = "-1"
	cidr_blocks = [ "0.0.0.0/0" ]
}
}		
resource "aws_security_group" "aws-SG-west-1-ssh" {
	description = "aws-SG-west-1-ssh"
	provider = aws.aws-west-1
	name = "aws-SG-west-1-ssh-${terraform.workspace}"
	vpc_id = aws_vpc.aws-vpc-west-1.id
	tags = {
		Name = "aws-SG-west-1-ssh-${terraform.workspace}"
}
ingress {
	description = "Allow Port 22"
	from_port = 22
	to_port = 22
	protocol = "tcp"
	cidr_blocks = [ "0.0.0.0/0" ]
}
egress {
	description = "Allow all ports and ips"
	from_port = 0
	to_port = 0
	protocol = "-1"
	cidr_blocks = [ "0.0.0.0/0" ]
}
}
resource "aws_security_group" "aws-SG-west-1-web" {
	description = "aws-SG-west-1-web"
	provider = aws.aws-west-1
	name = "aws-SG-west-1-web-${terraform.workspace}"
	vpc_id = aws_vpc.aws-vpc-west-1.id
	tags = {
		Name = "aws-SG-west-1-web-${terraform.workspace}"
}
ingress {
	description = "Allow Port 443"
	from_port = 443
	to_port = 443
	protocol = "tcp"
	cidr_blocks = [ "0.0.0.0/0" ]
}
ingress {
	description = "Allow Port 80"
	from_port = 80
	to_port = 80
	protocol = "tcp"
	cidr_blocks = [ "0.0.0.0/0" ]
}
egress {
	description = "Allow all ports and ips"
	from_port = 0
	to_port = 0
	protocol = "-1"
	cidr_blocks = [ "0.0.0.0/0" ]
}
}
#Resource Block-Instance
resource "aws_instance" "aws-instance-east-1" {
	ami = data.aws_ami.amzlinux1.id
	instance_type = "t2.micro"
	key_name = "Provisioner_Key"
	count = 1
	vpc_security_group_ids = [aws_security_group.aws-SG-east-1-ssh.id,aws_security_group.aws-SG-east-1-ssh.id]
	subnet_id = aws_subnet.aws-subnet1-east-1.id
	user_data = file("nginx.sh")
	tags = {
		Name = "aws-instance-east-1-${terraform.workspace}"
	}
		
}
resource "aws_instance" "aws-instance-east-1-file-provisioner" {
	ami = data.aws_ami.amzlinux1.id
	instance_type = "t2.micro"
	key_name = "Provisioner_Key"
	count = 1
	vpc_security_group_ids = [aws_security_group.aws-SG-east-1-ssh.id,aws_security_group.aws-SG-east-1-web.id]
	subnet_id = aws_subnet.aws-subnet2-east-1.id
	user_data = <<EOF
		sudo yum update -y
		sudo yum install httpd -y
		sudo systemctl enable httpd
		sudo systemctl start httpd
		echo "<h1>Hi Nani</h1>"
	EOF
	tags = {
		Name = "aws-instance-east-1-file-provisioner-${terraform.workspace}"
	}
		
	connection {
		type = "ssh"
		host = self.public_ip
		user = "ec2-user"
		password = "sai@25122018"
		private_key = file("privatekey/Provisioner_Key.pem")
	}
	provisioner "file" {
		source = "apps/app1folder"
		destination = "/tmp/app1folder"			
	}
	provisioner "file" {
		source = "apps/app2file"
		destination = "/tmp/app2file"
	}
}
resource "aws_instance" "aws-instance-east-2" {
	ami = data.aws_ami.amzlinux2.id
	instance_type = "t2.small"
	provider = aws.aws-east-2
	key_name = "NewEnthusiatickp"
	count = 1
	vpc_security_group_ids = [aws_security_group.aws-SG-east-2-ssh.id,aws_security_group.aws-SG-east-2-ssh.id]
	subnet_id = aws_subnet.aws-subnet1-east-2.id
	user_data = file("nginx.sh")
	tags = {
		Name = "aws-instance-east-2-${terraform.workspace}"
	}
		
}
resource "aws_instance" "aws-instance-east-2-remote-exec-provisioner" {
	ami = data.aws_ami.amzlinux2.id
	instance_type = "t2.small"
	provider = aws.aws-east-2
	key_name = "NewEnthusiatickp"
	count = 1
	vpc_security_group_ids = [aws_security_group.aws-SG-east-2-ssh.id,aws_security_group.aws-SG-east-2-web.id]
	subnet_id = aws_subnet.aws-subnet2-east-2.id
	user_data = <<EOF
		sudo yum update -y
		sudo yum install httpd -y
		sudo systemctl enable httpd
		sudo systemctl start httpd
		echo "<h1>Hi Nani</h1>"
	EOF
	tags = {
		Name = "aws-instance-east-2-file-provisioner-${terraform.workspace}"
	}
		
	connection {
		type = "ssh"
		host = self.public_ip
		user = "ec2-user"
		password = "sai@25122018"
		private_key = file("privatekey/Provisioner_Key.pem")
	}
	provisioner "file" {
		source = "apps/app1folder"
		destination = "/tmp/app1folder"			
	}
	provisioner "file" {
		source = "apps/app2file"
		destination = "/tmp/app2file"
	}
	provisioner "file" {
		source = "apps/file.html"
		destination = "/tmp/file.html"
	}
	provisioner "remote-exec" {
	inline = [
		"sleep 90",
		"sudo cp /tmp/file.html /var/www/html"
	]
}
}
resource "aws_instance" "aws-instance-west-1" {
	ami = data.aws_ami.amzlinux3.id
	instance_type = "t2.large"
	key_name = "California_Key"
	provider = aws.aws-west-1
	count = 1
	vpc_security_group_ids = [aws_security_group.aws-SG-west-1-ssh.id,aws_security_group.aws-SG-west-1-ssh.id]
	subnet_id = aws_subnet.aws-subnet1-west-1.id
	user_data = file("nginx.sh")
	tags = {
		Name = "aws-instance-west-1-${terraform.workspace}"
	}
		
}
	




	

			