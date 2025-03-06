# Read all YAML configuration files in the directory
locals {
  project_files = fileset("${path.module}/data/projects", "*.yaml")
  project_configs = {
    for file in local.project_files :
    replace(basename(file), ".yaml", "") => yamldecode(file("${path.module}/data/projects/${file}"))
  }
  #   project_configs = {
  #     for file in local.project_files :
  #     basename(file) => yamldecode(file("${path.module}/data/projects/${file}"))
  #   }
}

# Flatten the public_zones and private_zones lists, including the project name
locals {
  public_zones  = flatten([for k, v in local.project_configs : [for zone in v.dns.public_zones : merge(zone, { project = k, project_id = v.name })] if v.dns != null && v.dns.public_zones != null])
  private_zones = flatten([for k, v in local.project_configs : [for zone in v.dns.private_zones : merge(zone, { project = k, project_id = v.name })] if v.dns != null && v.dns.private_zones != null])
}

# Create DNS Public zones for each project
resource "google_dns_managed_zone" "public_zones" {
  for_each    = { for zone in local.public_zones : "${zone.project}-${zone.name}" => zone }
  name        = each.value.name
  project     = each.value.project_id
  dns_name    = each.value.dns_name
  description = each.value.description
}

# Create DNS Private zones for each project
resource "google_dns_managed_zone" "private_zones" {
  for_each    = { for zone in local.private_zones : "${zone.project}-${zone.name}" => zone }
  name        = each.value.name
  project     = each.value.project_id
  dns_name    = each.value.dns_name
  description = each.value.description
  visibility  = each.value.visibility
}

# Add nameservers to the parent DNS zone for each project
resource "google_dns_record_set" "parent_ns" {
  for_each     = google_dns_managed_zone.public_zones
  name         = each.value.name
  project      = "ten21-prod-net-landing-0"
  managed_zone = "cg-tentwentyone-io" # Parent zone
  type         = "NS"
  ttl          = 300
  rrdatas      = each.value.name_servers
}
