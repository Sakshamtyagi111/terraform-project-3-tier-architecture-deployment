locals {
  app_user_data = <<-EOF
    #!/bin/bash
    yum update -y
    yum install -y httpd php php-mysqlnd mariadb105-server
    systemctl start httpd
    systemctl enable httpd

    cat <<EOT > /var/www/html/index.php
    <html>
    <head><title>Saksham Tyagi Portfolio</title></head>
    <body style="text-align: center; font-family: Arial;">
        <h1>Hello, I am Saksham Tyagi</h1>
        <form method="POST">
            <input type="text" name="name" placeholder="Name" required><br>
            <input type="email" name="email" placeholder="Email" required><br>
            <button type="submit" name="save">Save to RDS</button>
        </form>
        <?php
        \$conn = new mysqli("${aws_db_instance.default.address}", "${var.user_name}", "${var.user_pass}", "db3tierproject");
        \$conn->query("CREATE TABLE IF NOT EXISTS guestbook (id INT AUTO_INCREMENT PRIMARY KEY, name VARCHAR(50), email VARCHAR(50))");
        if(isset(\$_POST['save'])){
            \$stmt = \$conn->prepare("INSERT INTO guestbook (name, email) VALUES (?, ?)");
            \$stmt->bind_param("ss", \$_POST['name'], \$_POST['email']);
            \$stmt->execute();
        }
        \$res = \$conn->query("SELECT * FROM guestbook");
        while(\$row = \$res->fetch_assoc()) { echo "Name: " . \$row["name"]. " | Email: " . \$row["email"]. "<br>"; }
        ?>
    </body>
    </html>
    EOT
  EOF
}

resource "aws_instance" "app_server_1" {
  ami                    = "ami-0440d3b780d96b29d"
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.private-subnet-1.id
  vpc_security_group_ids = [aws_security_group.vpc-app-tier-sg.id]
  user_data              = local.app_user_data
  tags                   = { Name = "app-1a" }
}

resource "aws_instance" "app_server_2" {
  ami                    = "ami-0440d3b780d96b29d"
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.private-subnet-2.id
  vpc_security_group_ids = [aws_security_group.vpc-app-tier-sg.id]
  user_data              = local.app_user_data
  tags                   = { Name = "app-1b" }
}