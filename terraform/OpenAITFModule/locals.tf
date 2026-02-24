locals {
  trustage_tags = {
    "cmdbAssetTag"     = var.cmdbAssetTag
    "cmdbFriendlyName" = var.cmdbFriendlyName
    "cmdbOwnedBy"      = var.cmdbOwnedBy
    "cmdbOwnedByEmail" = var.cmdbOwnedByEmail
    "cmdbPortfolio"    = var.cmdbPortfolio
  }
  acrname = var.environment == "prod" ? "acraiservicesprod" : "acraiservicesnonprod"

  flattened_models = merge([
    for account_key, account in var.openai_accounts : {
      for model_key, model in account.models :
      "${account_key}-${model_key}" => merge(model, {
        account_key = account_key
      })
    }
  ]...)

  filtered_container_apps = {
    for key, value in var.container_apps : key => value
    if lookup(value, "agw_enabled", false)
  }

  # Filter container apps that have rewrite rules enabled
  container_apps_with_rewrite = {
    for key, value in local.filtered_container_apps : key => value
    if lookup(value, "agw_rewrite_enabled", false) && lookup(value, "agw_rewrite_pattern", "") != ""
  }

}