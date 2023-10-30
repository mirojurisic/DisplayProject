## Details
This project is more complicated than others in that it has multiple tiers of components and also it will use Terraform for creating resources in the AWS and on top of this it will use Github Actions to deploy the code.
# Frontend app
Simple nodejs project that just has two pages to add, list and delete note(s) directly from the backend app. Frontend app does not have any access to mySQL database.
# Backend app
Simple nodejs project that just has connection to mySQL server and has simple endpoints to add, delete and list notes directly from mySQL server.
# Terraform project
This IaC will create following resources:
1) mySQL database(Managed RDS) inside private subnet
2) EC2 inside private subnet that will have access to mySQL database, on this instance will run Backend app. This instance will have access to internet via NAT gateway from public subnet (needed for updates).
3) EC2 inside public subnet that will have open connection to internet so that Frontend app can be accessed via internet(internet browser). This EC2 instance will have access to EC2 instance from private subnet but not access to subnet where mySQL database is located.
# Github Actions
There are 3 action workflows available:
1) terraform.yml will update the resources and configuration in the cloud
2) app_frontend.yml will update and deploy code to EC2 from public subnet
3) app_backend.yml will update and deploy code to EC2 from private subnet
----------------------------------------------------------------
Steps of the workflows include:
1) define action that will trigger this workflow
2) define os where agent is running
3) clone git repository
4) specific actions dependent on the workflow

