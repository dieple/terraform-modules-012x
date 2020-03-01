variable "account_data" {
  type = map(object({
    name                = string
    email               = string
    account_iam_billing = string
  }))
}

variable "tags" {
  type = map(string)
}