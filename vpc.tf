# vpc.tf
# Provisions the core networking infrastructure for the application, including VPC, subnets, internet gateway, and routing.

# Main Virtual Private Cloud (VPC) for isolating all resources
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16" # Large private address space
  enable_dns_support   = true           # Enable DNS resolution
  enable_dns_hostnames = true           # Enable DNS hostnames for instances
  tags = {
    Name        = "${var.project_name}-vpc"
    Environment = var.environment
  }
}

# Internet Gateway to allow internet access for public subnets
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name        = "${var.project_name}-igw"
    Environment = var.environment
  }
}

# Public subnet for resources that need internet access
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true # Automatically assign public IPs
  availability_zone       = "${var.aws_region}a"
  tags = {
    Name        = "${var.project_name}-public-subnet"
    Environment = var.environment
  }
}

# Private subnet for internal resources
resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "${var.aws_region}a"
  tags = {
    Name        = "${var.project_name}-private-subnet"
    Environment = var.environment
  }
}

# Route table for public subnet to route traffic to the internet
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0" # Route all outbound traffic
    gateway_id = aws_internet_gateway.gw.id
  }
  tags = {
    Name        = "${var.project_name}-public-rt"
    Environment = var.environment
  }
}

# Associate the public subnet with the public route table
resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
} 