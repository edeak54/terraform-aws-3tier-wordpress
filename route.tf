# public
resource "aws_route_table" "rt_public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

# associate subnet to rt
resource "aws_route_table_association" "assoc_public1" {
  subnet_id      = aws_subnet.public_1.id
  route_table_id = aws_route_table.rt_public.id
}

resource "aws_route_table_association" "assoc_public2" {
  subnet_id      = aws_subnet.public_2.id
  route_table_id = aws_route_table.rt_public.id
}


# for private nat 
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.gw.id
  }

  tags = {
    Name = "private-route-table"
  }
}

resource "aws_route_table_association" "app1" {
  subnet_id      = aws_subnet.private_1.id
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_route_table_association" "app2" {
  subnet_id      = aws_subnet.private_2.id
  route_table_id = aws_route_table.private_rt.id
}

