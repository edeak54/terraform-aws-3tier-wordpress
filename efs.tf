resource "aws_efs_file_system" "wp_storage" {
  creation_token = "wp_efs"
  encrypted      = true
}


resource "aws_efs_mount_target" "mount" {
  file_system_id  = aws_efs_file_system.wp_storage.id
  subnet_id       = aws_subnet.private_1.id
  security_groups = [aws_security_group.efs_sg.id]
}

resource "aws_efs_mount_target" "mount2" {
  file_system_id  = aws_efs_file_system.wp_storage.id
  subnet_id       = aws_subnet.private_2.id
  security_groups = [aws_security_group.efs_sg.id]
}


