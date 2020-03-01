# IAM User Module

This module performs the following:

- create IAM user access key and secret access key

## Inputs

| Name | Description | Default | Required |
|------|-------------|:-----:|:-----:|
| user | Username | - | yes |
| pgp_key | Base64-encoded PGP key | - | yes |

## Outputs

| Name | Description |
|------|-------------|
| aws_iam_user_access_key_id | Access key ID  |
| aws_iam_user_secret_access_key_encrypted_and_b64_encoded | Secret access key, encrypted with the PGP key provided above and base64 encoded. |

## Notes

To supply a public key compatible with Terraform, ensure it is in binary format and base64 encoded. 
For example:

1. Find PGP private key `dataops.pgp` in 1Password and import the key into your PGP keychain 
(there's a tool called GPG Suite for macOS to help: https://gpgtools.org) 
using the email found in the next step as the key name...
1. Export the public key in binary format using
```gpg --export dataops@xxxxxxxxxxxx.com > dataops.pub.bin```
1. This public key should be base64 encoded and supplied to terraform.


To __extract the secret access key__ use the following:

1. Import the private key `dataops.pgp` into your GPG keychain
1. Grab the value of aws_iam_user_secret_access_key_encrypted_and_b64_encoded output by terraform.
1. Base64 decode the value and decrypt it: `echo '<aws_iam_user_secret_access_key_encrypted_and_b64_encoded>' | base64 -D | gpg -d`
