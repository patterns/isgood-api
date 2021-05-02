
terraform {
  backend "remote" {
    organization = "saveclimate"

    workspaces {
      name = "demo"
    }
  }
}
