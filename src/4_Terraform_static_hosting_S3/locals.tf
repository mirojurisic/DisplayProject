
locals {
  #s3
  s3_bucket_name_webapp = "miro-webhosting-bucket"
  key                   = "index.html"
  source                = "./webapp/index.html"

}
