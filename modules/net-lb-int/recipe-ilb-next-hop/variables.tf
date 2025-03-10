/**
 * Copyright 2022 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

variable "_testing" {
  description = "Populate this variable to avoid triggering the data source."
  type = object({
    name             = string
    number           = number
    services_enabled = optional(list(string), [])
  })
  default = null
}

variable "ilb_right_enable" {
  description = "Route right to left traffic through ILB."
  type        = bool
  default     = false
}

variable "ilb_session_affinity" {
  description = "Session affinity configuration for ILBs."
  type        = string
  default     = "CLIENT_IP"
}

variable "ip_ranges" {
  description = "IP CIDR ranges used for VPC subnets."
  type        = map(string)
  default = {
    left  = "10.0.0.0/24"
    right = "10.0.1.0/24"
  }
}

variable "prefix" {
  description = "Prefix used for resource names."
  type        = string
  validation {
    condition     = var.prefix != ""
    error_message = "Prefix cannot be empty."
  }
}

variable "project_id" {
  description = "Existing project id."
  type        = string
}

variable "region" {
  description = "Region used for resources."
  type        = string
  default     = "europe-west1"
}

variable "zones" {
  description = "Zone suffixes used for instances."
  type        = list(string)
  default     = ["b", "c"]
}
