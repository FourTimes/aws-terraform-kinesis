#### Terraform kinesis code

```bash
terraform init
terraform plan -var-file=config.tfvars
terraform apply -var-file=config.tfvars -auto-approve
terraform destroy -var-file=config.tfvars -auto-approve
```