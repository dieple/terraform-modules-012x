# terraform-aws-key-pair


Terraform module for generating or importing an SSH public key file into AWS.


---

## Usage

```hcl
module "ssh_key_pair" {
  source                = "git::https://github.com/dieple/terraform-modules-012x.git//terraform-aws-key-pair"
  key_name              = "my-ssh-key"
  ssh_public_key_path   = "/secrets"
  generate_ssh_key      = "true"
  private_key_extension = ".pem"
  public_key_extension  = ".pub"
  chmod_command         = "chmod 600 %v"
}
```


```
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| chmod_command | Template of the command executed on the private key file | string | `chmod 600 %v` | no |
| generate_ssh_key | If set to `true`, new SSH key pair will be created | string | `false` | no |
| key_name | Name of Shh key pair | string | - | yes |
| private_key_extension | Private key extension | string | `` | no |
| public_key_extension | Public key extension | string | `.pub` | no |
| ssh_key_algorithm | SSH key algorithm | string | `RSA` | no |
| ssh_public_key_path | Path to SSH public key directory (e.g. `/secrets`) | string | - | yes |
| tags | Additional tags (e.g. map(`BusinessUnit`,`XYZ`) | map | `<map>` | no |

## Outputs

| Name | Description |
|------|-------------|
| key_name | Name of SSH key |
| private_key_filename | Private Key Filename |
| public_key | Contents of the generated public key |
| public_key_filename | Public Key Filename |



