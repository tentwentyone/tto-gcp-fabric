/**
 * Copyright 2024 Google LLC
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

# tfdoc:file:description Landing DNS zones and peerings setup.

# Public DNS for cg.tentwentyone.io
module "landing-dns-pub-cg" {
  source     = "../../../modules/dns"
  project_id = module.landing-project.project_id
  name       = "cg-tentwentyone-io"
  zone_config = {
    domain = "cg.tentwentyone.io."
    public = {}
  }
}
