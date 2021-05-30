
terraform {
  backend "remote" {
    organization = "massive-dynamic"
    workspaces {
      name = "dev-sandbox"
    }
  }
}
