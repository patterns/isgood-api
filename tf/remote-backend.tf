
terraform {
  backend "remote" {
    organization = "saveclimate"
    workspaces {
      name = "ghactions-demo"
    }
  }
}
