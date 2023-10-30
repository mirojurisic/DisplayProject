# # Create a database server
# resource "aws_db_instance" "default" {
#   engine         = "mysql"
#   engine_version = "5.6.17"
#   instance_class = "db.t1.micro"
#   username       = "rootuser"
#   password       = "rootpasswd"

#   # etc, etc; see aws_db_instance docs for more
# }


# Create a second database, in addition to the "initial_db" created
# by the aws_db_instance resource above.
resource "mysql_database" "app" {
  name = locals.db_name
}
