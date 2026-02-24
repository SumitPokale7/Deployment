resource "azurerm_public_ip" "agwaf" {
  name                = var.agwaf_azurerm_public_ip_name
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = "Static"
  sku                 = "Standard"

  tags = local.trustage_tags
}

resource "azurerm_web_application_firewall_policy" "owasp_geoblock" {
  name                = "wafpolicy-owasp-geoblock"
  resource_group_name = var.resource_group_name
  location            = var.location

  custom_rules {
    name      = "blockBlacklistedCountries"
    priority  = 1
    rule_type = "MatchRule"

    match_conditions {
      match_variables {
        variable_name = "RemoteAddr"
      }

      operator           = "GeoMatch"
      negation_condition = false
      # match_values       = var.black_listed_countries
      match_values = var.black_listed_countries

    }

    action = "Block"
  }

  policy_settings {
    enabled                     = true
    mode                        = "Prevention"
    request_body_check          = true
    file_upload_limit_in_mb     = 100
    max_request_body_size_in_kb = 512
  }

  managed_rules {

    managed_rule_set {
      type    = "OWASP"
      version = "3.2"
      rule_group_override {
        rule_group_name = "REQUEST-942-APPLICATION-ATTACK-SQLI"
        # Most problematic rules for chat applications - set to Log only
        rule {
          id      = "942200" # MySQL comment/space obfuscation
          enabled = true
          action  = "Log"
        }
        rule {
          id      = "942260" # Basic SQL authentication bypass
          enabled = true
          action  = "Log"
        }
        rule {
          id      = "942330" # Classic SQL injection probes 1
          enabled = true
          action  = "Log"
        }
        rule {
          id      = "942340" # Basic SQL injection attempts
          enabled = true
          action  = "Log"
        }
        rule {
          id      = "942370" # Classic SQL injection probes 2
          enabled = true
          action  = "Log"
        }
        rule {
          id      = "942380" # SQL injection attacks
          enabled = true
          action  = "Log"
        }
        rule {
          id      = "942440" # SQL comment sequence detection
          enabled = true
          action  = "Log"
        }
        rule {
          id      = "942450" # SQL hex encoding
          enabled = true
          action  = "Log"
        }
        rule {
          id      = "942470" # SQL injection via stored procedures
          enabled = true
          action  = "Log"
        }
      }
    }

    dynamic "exclusion" {
      for_each = var.environment == "prod" ? [] : [1] # Only include this block if the environment is "dev" and "Demo"
      content {
        match_variable          = "RequestArgNames" # Exclude based on request argument names
        selector                = "search_filters"  # Selector for the exclusion
        selector_match_operator = "Contains"        # Match operator for the selector

        excluded_rule_set {
          type    = "OWASP" # Rule set type
          version = "3.2"   # Rule set version

          rule_group {
            rule_group_name = "REQUEST-931-APPLICATION-ATTACK-RFI" # Rule group to exclude
            excluded_rules = [                                     # List of excluded rules
              "931100",
              "931110",
              "931120",
              "931130",
            ]
          }
        }
      }
    }

    # Add this new exclusion block for urls_scrape
    dynamic "exclusion" {
      for_each = var.environment == "prod" ? [] : [1]
      content {
        match_variable          = "RequestArgNames"
        selector                = "urls_scrape"
        selector_match_operator = "Contains"

        excluded_rule_set {
          type    = "OWASP"
          version = "3.2"

          rule_group {
            rule_group_name = "REQUEST-931-APPLICATION-ATTACK-RFI"
            excluded_rules = [
              "931100",
              "931110",
              "931120",
              "931130",
            ]
          }
        }
      }
    }

    # DYNAMIC: _bti cookie exclusion - resolves false positives from application identity cookie
    dynamic "exclusion" {
      for_each = contains(["dev", "demo", "prod"], var.environment) ? [1] : [] # Enabled for: dev, demo, prod
      content {
        match_variable          = "RequestCookieNames"
        selector                = "_bti"
        selector_match_operator = "Equals"

        excluded_rule_set {
          type    = "OWASP"
          version = "3.2"

          rule_group {
            rule_group_name = "REQUEST-942-APPLICATION-ATTACK-SQLI"
            excluded_rules = [
              "942200", # MySQL comment/space/tab detection
              "942260", # Detects basic SQL authentication bypass attempts 1/3
              "942340", # Detects basic SQL injection and SQLLFI attempts
              "942370", # Detects classic SQL injection probings 1/2
            ]
          }
        }
      }
    }

    # 1. DYNAMIC: COMPREHENSIVE ARGUMENT NAME EXCLUSIONS
    # Handles all common chat parameters in URLs and form data
    dynamic "exclusion" {
      for_each = contains(["dev", "demo", "prod"], var.environment) ? [
        "message", "query", "prompt", "content", "input", "text", "data",
        "payload", "body", "request", "chat", "conversation", "response",
        "answer", "question", "instruction", "system", "user", "assistant",
        "context", "history", "thread", "session", "completion", "generate"
      ] : [] # Enabled for: dev, demo, prod
      content {
        match_variable          = "RequestArgNames"
        selector                = exclusion.value
        selector_match_operator = "Contains"

        excluded_rule_set {
          type    = "OWASP"
          version = "3.2"

          rule_group {
            rule_group_name = "REQUEST-942-APPLICATION-ATTACK-SQLI"
            excluded_rules = [
              "942100", "942110", "942120", "942130", "942140", "942150", "942160",
              "942170", "942180", "942190", "942200", "942210", "942220", "942230",
              "942240", "942250", "942260", "942270", "942280", "942290", "942300",
              "942310", "942320", "942330", "942340", "942350", "942360", "942370",
              "942380", "942390", "942400", "942410", "942420", "942430", "942440",
              "942450", "942460", "942470", "942480", "942490", "942500"
            ]
          }

          rule_group {
            rule_group_name = "REQUEST-941-APPLICATION-ATTACK-XSS"
            excluded_rules = [
              "941100", "941110", "941120", "941130", "941140", "941150", "941160",
              "941170", "941180", "941190", "941200", "941210", "941220", "941230",
              "941240", "941250", "941260", "941270", "941280", "941290", "941300",
              "941310", "941320", "941330", "941340", "941350", "941360"
            ]
          }
        }
      }
    }

    # 2. DYNAMIC: ARGUMENT VALUES EXCLUSIONS
    # Handles the actual content of parameters, not just their names

    dynamic "exclusion" {
      for_each = contains(["dev", "demo", "prod"], var.environment) ? [
        "message", "query", "prompt", "content", "input", "text", "data",
        "payload", "body", "request", "chat", "conversation", "response",
        "answer", "question", "instruction", "system", "user", "assistant",
        "context", "history", "thread", "session", "completion", "generate"
      ] : [] # Enabled for: dev, demo, prod
      content {
        match_variable          = "RequestArgValues"
        selector                = exclusion.value
        selector_match_operator = "Contains"

        excluded_rule_set {
          type    = "OWASP"
          version = "3.2"

          rule_group {
            rule_group_name = "REQUEST-942-APPLICATION-ATTACK-SQLI"
            excluded_rules = [
              "942100", "942110", "942120", "942130", "942140", "942150", "942160",
              "942170", "942180", "942190", "942200", "942210", "942220", "942230",
              "942240", "942250", "942260", "942270", "942280", "942290", "942300",
              "942310", "942320", "942330", "942340", "942350", "942360", "942370",
              "942380", "942390", "942400", "942410", "942420", "942430", "942440",
              "942450", "942460", "942470", "942480", "942490", "942500"
            ]
          }

          rule_group {
            rule_group_name = "REQUEST-941-APPLICATION-ATTACK-XSS"
            excluded_rules = [
              "941100", "941110", "941120", "941130", "941140", "941150", "941160",
              "941170", "941180", "941190", "941200", "941210", "941220", "941230",
              "941240", "941250", "941260", "941270", "941280", "941290", "941300"
            ]
          }

          rule_group {
            rule_group_name = "REQUEST-931-APPLICATION-ATTACK-RFI"
            excluded_rules = [
              "931100", "931110", "931120", "931130"
            ]
          }
        }
      }
    }


  }

  # DYNAMIC: Whitelist VPN IP addresses - only allow these IPs to access the application
  dynamic "custom_rules" {
    for_each = contains(["dev", "demo", "prod"], var.environment) ? [1] : [] # Only enabled for dev, demo & prod environment
    content {
      action    = "Allow"
      enabled   = true
      name      = "AllowVPNIPs"
      priority  = 2
      rule_type = "MatchRule"

      match_conditions {
        match_values = [
          "208.91.239.10/32",
          "208.91.239.11/32",
          "208.91.237.161/32",
          "208.91.237.162/32",
          "208.91.239.30/32",
          "208.91.237.190/32",
          "208.91.236.126/32",
          "208.91.238.126/32",
          "198.245.150.222/32",
          "208.91.239.1/32",
          "20.94.99.16/28",
          "20.80.45.128/28",
          "172.177.156.178/32"
        ]
        negation_condition = false
        operator           = "IPMatch"
        transforms         = []

        match_variables {
          variable_name = "RemoteAddr"
        }
      }
    }
  }

  # DYNAMIC: Block non-VPN IP addresses (default deny rule)
  dynamic "custom_rules" {
    for_each = contains(["dev", "demo", "prod"], var.environment) ? [1] : [] # Only enabled for dev & demo & prod environment
    content {
      action    = "Block"
      enabled   = true
      name      = "BlockNonVPNIPs"
      priority  = 5
      rule_type = "MatchRule"

      match_conditions {
        match_values = [
          "208.91.239.10/32",
          "208.91.239.11/32",
          "208.91.237.161/32",
          "208.91.237.162/32",
          "208.91.239.30/32",
          "208.91.237.190/32",
          "208.91.236.126/32",
          "208.91.238.126/32",
          "198.245.150.222/32",
          "208.91.239.1/32",
          "20.94.99.16/28",
          "20.80.45.128/28",
          "34.195.146.191", # Include Veracode IP
          var.apim_ip
        ]
        negation_condition = true # Block IPs NOT in VPN/Veracode ranges
        operator           = "IPMatch"
        transforms         = []

        match_variables {
          variable_name = "RemoteAddr"
        }
      }
    }
  }

  custom_rules {
    action    = "Allow"
    enabled   = true
    name      = "Veracode"
    priority  = 3
    rule_type = "MatchRule"

    match_conditions {
      match_values = [
        "34.195.146.191",
      ]
      negation_condition = false
      operator           = "IPMatch"
      transforms         = []

      match_variables {
        variable_name = "RemoteAddr"

      }
    }
  }

  tags = local.trustage_tags
}

resource "azurerm_application_gateway" "agwaf" {
  name                = var.agwaf_name
  resource_group_name = var.resource_group_name
  location            = var.location

  sku {
    name     = "WAF_v2"
    tier     = "WAF_v2"
    capacity = 2
  }

  firewall_policy_id = azurerm_web_application_firewall_policy.owasp_geoblock.id

  gateway_ip_configuration {
    name      = "agwaf-gateway-ip-config"
    subnet_id = azurerm_subnet.agwaf_subnet.id
  }

  frontend_port {
    name = "frontend-port-ssl"
    port = 443
  }

  frontend_ip_configuration {
    name                 = "agwaf-frontend-ip-config"
    public_ip_address_id = azurerm_public_ip.agwaf.id
  }

  # Dynamic block for backend address pool for "investment frontend"
  dynamic "backend_address_pool" {
    for_each = var.environment == "dev" ? [] : [1]
    content {
      name  = "address-pool-frontend-inv"
      fqdns = [var.backend_address_pool_frontend_inv]
    }
  }

  # Dynamic block for probe for "investment"
  dynamic "probe" {
    for_each = var.environment == "dev" ? [] : [1] # Include this block for non-"dev" environments
    content {
      name                                      = "backend-health-probe-inv"
      interval                                  = "30"
      timeout                                   = "30"
      protocol                                  = "Https"
      path                                      = "/investmentapi/health"
      unhealthy_threshold                       = "3"
      pick_host_name_from_backend_http_settings = true
    }

  }

  # Dynamic block for backend address pool for "investment backend"
  dynamic "backend_address_pool" {
    for_each = var.environment == "dev" ? [] : [1]
    content {
      name  = "address-pool-backend-inv"
      fqdns = [var.backend_address_pool_backend_inv]
    }

  }

  # Dynamic block for backend http settings for "investment"
  dynamic "backend_http_settings" {
    for_each = var.environment == "dev" ? [] : [1] # Include this block for non-"dev" environments
    content {
      name                                = "http-settings-backend-inv"
      cookie_based_affinity               = "Disabled"
      port                                = 443
      protocol                            = "Https"
      request_timeout                     = 90
      pick_host_name_from_backend_address = true
      probe_name                          = "backend-health-probe-inv"
    }
  }

  # Frontend HTTP settings for investment
  dynamic "backend_http_settings" {
    for_each = var.environment == "dev" ? [] : [1] # Include this block for non-"dev" environments
    content {
      name                                = "http-settings-frontend-inv"
      cookie_based_affinity               = "Disabled"
      port                                = 443
      protocol                            = "Https"
      request_timeout                     = 90
      pick_host_name_from_backend_address = true
    }
  }

  ssl_certificate {
    name     = "front-end-cert"
    data     = data.azurerm_key_vault_secret.atlas_kv_front_end_cert_secret.value
    password = data.azurerm_key_vault_secret.atlas_kv_front_end_cert_password.value
  }

  ssl_policy {
    policy_type = "Predefined"
    policy_name = "AppGwSslPolicy20220101S"
  }

  http_listener {
    name                           = "https-listener-frontend"
    frontend_ip_configuration_name = "agwaf-frontend-ip-config"
    frontend_port_name             = "frontend-port-ssl"
    protocol                       = "Https"
    ssl_certificate_name           = "front-end-cert"
    # host_name = "chatdev.trustage.com"
    dynamic "custom_error_configuration" {
      for_each = contains(["dev", "demo", "prod"], var.environment) ? [1] : [] # Only include this block if the environment is "dev" or "demo" & "prod"
      content {
        custom_error_page_url = var.static_error_page_url_403
        status_code           = "HttpStatus403"
      }
    }
  }

  # DYNAMIC CONTAINER APP CONFIGURATIONS
  # Filter container apps that should be included in this environment
  # Dynamic backend address pools for container apps
  dynamic "backend_address_pool" {
    for_each = local.filtered_container_apps
    content {
      name  = "address-pool-${backend_address_pool.key}-containerapp"
      fqdns = [azurerm_container_app.container_apps[backend_address_pool.key].ingress[0].fqdn]
    }
  }

  # Dynamic probes for container apps
  dynamic "probe" {
    for_each = local.filtered_container_apps
    content {
      name                                      = "${probe.key}-containerapp-health-probe"
      interval                                  = lookup(probe.value, "agw_probe_interval", 30)
      timeout                                   = lookup(probe.value, "agw_probe_timeout", 30)
      protocol                                  = "Https"
      path                                      = probe.value.liveness_probe_path
      unhealthy_threshold                       = lookup(probe.value, "agw_probe_unhealthy_threshold", 3)
      pick_host_name_from_backend_http_settings = true
    }
  }

  # Dynamic backend HTTP settings for container apps
  dynamic "backend_http_settings" {
    for_each = local.filtered_container_apps
    content {
      name                                = "http-settings-${backend_http_settings.key}-containerapp"
      cookie_based_affinity               = "Disabled"
      port                                = 443
      protocol                            = "Https"
      request_timeout                     = lookup(backend_http_settings.value, "agw_request_timeout", 90)
      pick_host_name_from_backend_address = true
      probe_name                          = "${backend_http_settings.key}-containerapp-health-probe"
    }
  }

  # Path based Routing Rule
  request_routing_rule {
    name               = "app-front-end-request-routing-rule"
    rule_type          = "PathBasedRouting"
    http_listener_name = "https-listener-frontend"
    url_path_map_name  = "path-map"
    priority           = 9
  }

  rewrite_rule_set {
    name = "uri-rewrite"

    # dynamic block for investment rewrite rule
    dynamic "rewrite_rule" {
      for_each = var.environment == "dev" ? [] : [1] # Include this block for non-"dev" environments
      content {
        name          = "rewrite-investment-path"
        rule_sequence = 100

        condition {
          variable    = "var_uri_path"
          pattern     = "/investment/(.*)"
          ignore_case = true
        }

        url {
          components = "path_only"
          path       = "/{var_uri_path_1}"
        }
      }
    }

    # dynamic block for Content-Security-Policy rewrite rule
    rewrite_rule {
      name          = "Content-Security-Policy"
      rule_sequence = 10
      response_header_configuration {
        header_name  = "Content-Security-Policy"
        header_value = var.environment == "dev" ? "default-src 'self'; script-src 'self' 'sha256-eV3QMumkWxytVHa/LDvu+mnW+PcSAEI4SfFu0iIlbDc=' https://cdn.jsdelivr.net https://cdnjs.cloudflare.com; img-src 'self' data: https://fastapi.tiangolo.com https://dev.azure.com https://*.gstatic.com https://www.google.com https://${var.storage_Name}.blob.core.windows.net; style-src 'self' 'unsafe-inline' https://fonts.googleapis.com https://cdn.jsdelivr.net; font-src 'self' https://fonts.gstatic.com; object-src 'none'; frame-ancestors 'none'; base-uri 'self'; form-action 'self';connect-src 'self' https://federationdemo.trustage.com https://${var.storage_Name}.blob.core.windows.net blob:; worker-src 'self' blob:;" : var.environment == "demo" ? "default-src 'self'; script-src 'self' 'sha256-TsjSCX4yUK50HmnZXTe4FVW3iPTz1cIqzuXQu1ozcFU=' https://cdn.jsdelivr.net https://cdnjs.cloudflare.com; img-src 'self' data: https://fastapi.tiangolo.com https://dev.azure.com https://${var.investment_storage_Name}.blob.core.windows.net https://${var.storage_Name}.blob.core.windows.net; style-src 'self' 'unsafe-inline' https://fonts.googleapis.com https://cdn.jsdelivr.net; font-src 'self' https://fonts.gstatic.com; object-src 'none'; frame-ancestors 'none'; base-uri 'self'; form-action 'self';connect-src 'self' https://federationdemo.trustage.com https://${var.investment_storage_Name}.blob.core.windows.net https://${var.storage_Name}.blob.core.windows.net blob:; worker-src 'self' blob:;" : "default-src 'self'; script-src 'self' 'sha256-TsjSCX4yUK50HmnZXTe4FVW3iPTz1cIqzuXQu1ozcFU=' https://cdn.jsdelivr.net https://cdnjs.cloudflare.com; img-src 'self' data: https://fastapi.tiangolo.com https://dev.azure.com https://${var.investment_storage_Name}.blob.core.windows.net https://${var.storage_Name}.blob.core.windows.net; style-src 'self' 'unsafe-inline' https://fonts.googleapis.com https://cdn.jsdelivr.net; font-src 'self' https://fonts.gstatic.com; object-src 'none'; frame-ancestors 'none'; base-uri 'self'; form-action 'self';connect-src 'self' https://federation.trustage.com https://${var.investment_storage_Name}.blob.core.windows.net https://${var.storage_Name}.blob.core.windows.net blob:; worker-src 'self' blob:;"
      }
    }
    rewrite_rule {
      name          = "Strict-Transport-Security"
      rule_sequence = 13
      response_header_configuration {
        header_name  = "Strict-Transport-Security"
        header_value = "max-age=31536000; includeSubDomains; preload"
      }
    }

    # DYNAMIC REWRITE RULES FOR CONTAINER APPS
    dynamic "rewrite_rule" {
      for_each = local.container_apps_with_rewrite
      content {
        name          = "rewrite-${rewrite_rule.key}-path"
        rule_sequence = lookup(rewrite_rule.value, "agw_rewrite_sequence", 50)

        condition {
          variable    = "var_uri_path"
          pattern     = rewrite_rule.value.agw_rewrite_pattern
          ignore_case = true
        }

        url {
          components = "path_only"
          path       = rewrite_rule.value.agw_rewrite_path
        }
      }
    }

  }

  # URL Path Map - Define Path based Routing
  url_path_map {
    name = "path-map"
    # default_redirect_configuration_name = local.redirect_configuration_name
    default_backend_address_pool_name  = "address-pool-chat_app_frontend-containerapp"
    default_backend_http_settings_name = "http-settings-chat_app_frontend-containerapp"

    # dynamic block for investment winldcard frontend path rule
    dynamic "path_rule" {
      for_each = var.environment == "dev" ? [] : [1] # Include this block for non-"dev" environments
      content {
        name                       = "frontend-rule-inv"
        paths                      = ["/investment/*"]
        backend_address_pool_name  = "address-pool-frontend-inv"
        backend_http_settings_name = "http-settings-frontend-inv"
        rewrite_rule_set_name      = "uri-rewrite"
      }
    }
    # dynamic block for investment frontend path rule
    dynamic "path_rule" {
      for_each = var.environment == "dev" ? [] : [1] # Include this block for non-"dev" environments
      content {
        name                       = "frontend-rule-inv-1"
        paths                      = ["/investment"]
        backend_address_pool_name  = "address-pool-frontend-inv"
        backend_http_settings_name = "http-settings-frontend-inv"
        rewrite_rule_set_name      = "uri-rewrite"
      }

    }

    # dynamic block for investment backend path rule
    dynamic "path_rule" {
      for_each = var.environment == "dev" ? [] : [1] # Include this block for non-"dev" environments
      content {
        name                       = "backend-rule-inv"
        paths                      = ["/investmentapi/*"]
        backend_address_pool_name  = "address-pool-backend-inv"
        backend_http_settings_name = "http-settings-backend-inv"
        rewrite_rule_set_name      = "uri-rewrite"
      }
    }


    # DYNAMIC PATH RULES FOR CONTAINER APPS
    dynamic "path_rule" {
      for_each = local.filtered_container_apps
      content {
        name                       = "containerapp-${path_rule.key}-rule"
        paths                      = lookup(path_rule.value, "agw_path_patterns", ["/${path_rule.key}/*"])
        backend_address_pool_name  = "address-pool-${path_rule.key}-containerapp"
        backend_http_settings_name = "http-settings-${path_rule.key}-containerapp"
        rewrite_rule_set_name      = "uri-rewrite"
      }
    }

  }

  tags = local.trustage_tags
}

