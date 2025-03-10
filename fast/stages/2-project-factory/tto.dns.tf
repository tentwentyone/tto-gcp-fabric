# Read all YAML configuration files in the directory
locals {
  project_files = fileset("${path.module}/data/projects", "*.yaml")
  project_configs = {
    for file in local.project_files :
    replace(basename(file), ".yaml", "") => yamldecode(file("${path.module}/data/projects/${file}"))
  }
}

# Flatten the public_zones and private_zones lists, including the project name
locals {
  public_zones  = flatten([for k, v in local.project_configs : [for zone in lookup(v.dns, "public_zones", []) : merge(zone, { project = k, project_id = v.name })]])
  private_zones = flatten([for k, v in local.project_configs : [for zone in lookup(v.dns, "private_zones", []) : merge(zone, { project = k, project_id = v.name })]])
}

# Create DNS Public zones for each project
module "public_dns_zone" {
  for_each    = { for zone in local.public_zones : "${zone.dns_name}" => zone }
  source      = "../../../modules/dns"
  project_id  = each.value.project_id
  description = each.value.description
  name        = each.value.name
  zone_config = {
    domain = each.value.dns_name
    public = {}
  }
}

# Create DNS Private zones for each project
module "private_dns_zone" {
  for_each    = { for zone in local.private_zones : "${zone.dns_name}" => zone }
  source      = "../../../modules/dns"
  project_id  = each.value.project_id
  description = each.value.description
  name        = each.value.name
  zone_config = {
    domain = each.value.dns_name
    private = {
      client_networks = [for network in each.value.client_networks : network]
    }

  }
}


# Add nameservers to the parent DNS zone for each project
resource "google_dns_record_set" "parent_ns" {
  for_each     = module.public_dns_zone
  name         = each.value.name
  project      = "ten21-prod-net-landing-0"
  managed_zone = "cg-tentwentyone-io" # Parent zone
  type         = "NS"
  ttl          = 300
  rrdatas      = each.value.name_servers
}
