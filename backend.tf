terraform {
  cloud {
    organization = "korede011"

    workspaces {
      name = "example-workspace"
    }
  }
}