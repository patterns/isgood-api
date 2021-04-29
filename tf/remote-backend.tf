terraform {
  backend "remote" {
    organization = "saveclimate"

    workspaces {
      name = "vault-demo"
    }
  }
}
