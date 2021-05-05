
terraform {
  backend "remote" {
    organization = "isgood-infra"
    workspaces {
      name = "ghactions-demo"
    }
  }
}
