terraform {
  required_version = ">= 1.6.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
  }
}

variable "suscription_id" {
  type        = string
  description = "Azure subscription id"
}

variable "sqladmin_username" {
  type        = string
  description = "Administrator username for SQL Server"
  sensitive   = true
}

variable "sqladmin_password" {
  type        = string
  description = "Administrator password for SQL Server"
  sensitive   = true
}

provider "azurerm" {
  features {}
  subscription_id = var.suscription_id
}

resource "random_integer" "suffix" {
  min = 100
  max = 999
}

resource "azurerm_resource_group" "rg" {
  name     = "upt-arg-${random_integer.suffix.result}"
  location = "eastus"
}

resource "azurerm_service_plan" "appserviceplan" {
  name                = "upt-asp-${random_integer.suffix.result}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  os_type             = "Linux"
  sku_name            = "B1"
}

resource "azurerm_linux_web_app" "webapp" {
  name                = "upt-awa-${random_integer.suffix.result}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  service_plan_id     = azurerm_service_plan.appserviceplan.id
  https_only          = true

  identity {
    type = "SystemAssigned"
  }

  site_config {
    minimum_tls_version = "1.2"
    always_on           = true
    ftps_state          = "Disabled"

    application_stack {
      docker_image_name   = "mcr.microsoft.com/dotnet/samples:aspnetapp"
      docker_registry_url = "https://mcr.microsoft.com"
    }
  }

  logs {
    http_logs {
      file_system {
        retention_in_days = 7
        retention_in_mb   = 35
      }
    }
  }
}

resource "azurerm_mssql_server" "sqlsrv" {
  name                          = "upt-dbs-${random_integer.suffix.result}"
  resource_group_name           = azurerm_resource_group.rg.name
  location                      = azurerm_resource_group.rg.location
  version                       = "12.0"
  administrator_login           = var.sqladmin_username
  administrator_login_password  = var.sqladmin_password
  minimum_tls_version           = "1.2"
  public_network_access_enabled = false
}

resource "azurerm_mssql_database" "sqldb" {
  name           = "shorten"
  server_id      = azurerm_mssql_server.sqlsrv.id
  sku_name       = "Basic"
  zone_redundant = false
}

output "resource_group_name" {
  value = azurerm_resource_group.rg.name
}

output "web_app_name" {
  value = azurerm_linux_web_app.webapp.name
}
