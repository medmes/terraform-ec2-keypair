# terraform-ec2-keypair


This code is for purpose to demonstate how to generate key pair dynamically FOR YOUR AWS EC2!
This demo also let you to store keys(private/public) in your terraform output and in an external file to use them later.

Code Structure: 
```
├── main.tf # terraform main code
├── outputs.tf # Output , you can run terraform output "output_name" command.
└── variables.tf # terraform variables.
```

After pulling code You can launch the demo by:
```
terraform init
terraform plan
terraform apply
```

