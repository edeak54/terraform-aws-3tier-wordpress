# launch template
resource "aws_launch_template" "wp_template" {
  name_prefix   = "wp-launch-template"
  image_id      = "ami-098e39bafa7e7303d"
  instance_type = "t3.micro"

  vpc_security_group_ids = [aws_security_group.ec2_sg.id]

  user_data = base64encode(<<-EOF
    #!/bin/bash
    yum update -y
    yum install -y httpd php php-mysqlnd amazon-efs-utils
    
    # Mount EFS
    mkdir -p /var/www/html
    mount -t efs ${aws_efs_file_system.wp_storage.id}:/ /var/www/html
    
    # Install WordPress
    wget https://wordpress.org/latest.tar.gz
    tar -xzf latest.tar.gz
    cp -r wordpress/* /var/www/html/
    chown -R apache:apache /var/www/html
    systemctl start httpd
    systemctl enable httpd
  EOF
  )
}

# asg
resource "aws_autoscaling_group" "wp_asg" {
  name_prefix = "wp-asg"
  launch_template {
    id      = aws_launch_template.wp_template.id
    version = "$Latest"
  }
  min_size         = 1
  max_size         = 3
  desired_capacity = 2

  vpc_zone_identifier = [aws_subnet.public_1.id, aws_subnet.public_2.id]

  target_group_arns = [aws_lb_target_group.wp_tg.arn]

}
