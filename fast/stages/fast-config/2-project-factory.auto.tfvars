# use `gcloud beta billing accounts list`
# if you have too many accounts, check the Cloud Console :)
billing_account = {
  id           = "01C8D5-E4EA95-F2D624"
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

outputs_location = "~/fast-config"

prefix = "ten21"

