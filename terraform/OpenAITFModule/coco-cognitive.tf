resource "azurerm_cognitive_account" "cocoopenaieus2" {
        count               = var.environment == "prod" ? 1 : 0
        name                = "coco-cognitive-account-eus"
        location            = "eastus2"
        resource_group_name = var.resource_group_name
        kind                = "OpenAI"
        sku_name            = "S0"
        custom_subdomain_name = "coco-cognitive-account-eus" # must be globally unique

		network_acls {
			default_action = "Deny"
			ip_rules = [
				"208.91.239.10",
				"208.91.239.11",
				"208.91.237.161",
				"208.91.237.162",
				"208.91.239.30",
				"208.91.237.190",
				"208.91.236.126",
				"208.91.238.126",
				"198.245.150.222",
				"208.91.239.1",
				"20.94.99.16/28",
				"20.80.45.128/28",
				"172.177.156.178"
			]
		}
		# tags = var.tags # Uncomment and define var.tags if you want to use tags
	}

resource "azurerm_cognitive_deployment" "gpt4oeus2" {
    count                = var.environment == "prod" ? 1 : 0
    name                 = "gpt-4o"
    cognitive_account_id = azurerm_cognitive_account.cocoopenaieus2[0].id
    model {
        format  = "OpenAI"
        name    = "gpt-4o"
    }
    sku {
        name     = "Standard"
        capacity = 250
    }
    lifecycle {
        ignore_changes = [model[0].version]
    }
}
resource "azurerm_cognitive_deployment" "cocoembeddingeus2" {
  count                = var.environment == "prod" ? 1 : 0
  name                 = "text-embedding-ada-002"
  cognitive_account_id = azurerm_cognitive_account.cocoopenaieus2[0].id
  model {
    format  = "OpenAI"
    name    = "text-embedding-ada-002"
    version = "2"
  }

  sku {
    name     = "Standard"
    capacity = 150
  }
}
