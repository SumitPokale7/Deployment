terraform {
  cloud {
    organization = "TruStage"
    workspaces {
      name = "__WORKSPACE_NAME__"
    }
  }
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
    }
  }
}

provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy    = true
      recover_soft_deleted_key_vaults = true

    }
    cognitive_account {
      purge_soft_delete_on_destroy = true
    }
  }
  subscription_id            = var.subscription_id
  tenant_id                  = "a00452fd-8469-409e-91a8-bb7a008e2da0" # leave hard coded
  skip_provider_registration = true
}

resource "random_string" "random" {
  length  = 4
  special = false
}

data "http" "myip" {
  url = "https://ipv4.icanhazip.com"
}

output "agentip" {
  value = ["${chomp(data.http.myip.response_body)}"]
}
