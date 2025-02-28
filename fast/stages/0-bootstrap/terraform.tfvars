# use `gcloud beta billing accounts list`
# if you have too many accounts, check the Cloud Console :)
billing_account = {
  id           = "01A59E-2AF0CC-DB17DA"
  is_org_level = false
}

# locations for GCS, BigQuery, and logging buckets created here
locations = {
  bq      = "EU"
  gcs     = "EU"
  logging = "europe-west4"
  pubsub  = []
}

# use `gcloud organizations list`
organization = {
  domain      = "tentwentyone.io"
  id          = 350989124418
  customer_id = "C01oeotpq"
}

outputs_location = "../fast-config"

prefix = "ten21"
