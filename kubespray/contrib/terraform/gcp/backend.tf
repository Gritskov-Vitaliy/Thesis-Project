terraform {
  backend "gcs" {
    bucket  = "my_tfstate_bucket"
    prefix  = "thesis/terraform/state"
    credentials = "~/gcloud.json"
  }
}
