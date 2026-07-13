# Terraform remote state migration

## What changed

This project now configures Terraform to store state in the Google Cloud Storage
(GCS) backend. The backend uses the following values:

- Bucket: `<GCS_BUCKET_NAME>`
- Prefix: `terraform/state`

No resources, modules, provider settings, variables, outputs, or local state
files were changed.

## Why this change is required

The local backend stores state in `terraform.tfstate` on the machine where
Terraform is run. A GCS backend provides a shared, durable location for the
same state, so Terraform can safely manage the existing infrastructure from
authorized environments without changing that infrastructure.

## Create and secure the state bucket

Replace `<GCS_BUCKET_NAME>` with a globally unique bucket name, and replace
`<GCS_PROJECT_ID>` and `<GCS_BUCKET_LOCATION>` with values appropriate for
your environment. Create the bucket manually:

```sh
gcloud storage buckets create gs://<GCS_BUCKET_NAME> \
  --project=<GCS_PROJECT_ID> \
  --location=<GCS_BUCKET_LOCATION> \
  --uniform-bucket-level-access
```

Enable Object Versioning:

```sh
gcloud storage buckets update gs://<GCS_BUCKET_NAME> --versioning
```

Enable Uniform Bucket-Level Access (safe to run if it was set during creation):

```sh
gcloud storage buckets update gs://<GCS_BUCKET_NAME> \
  --uniform-bucket-level-access
```

Enable Public Access Prevention:

```sh
gcloud storage buckets update gs://<GCS_BUCKET_NAME> \
  --public-access-prevention
```

Grant the identity that runs Terraform sufficient access to the bucket, such
as `roles/storage.objectAdmin` on this bucket. Do not grant public access.

## Migrate the existing local state

1. Update `backend.tf`, replacing `<GCS_BUCKET_NAME>` with the bucket name.
2. Ensure the Terraform-running identity can read and write objects in that
   bucket.
3. From this directory, run:

   ```sh
   terraform init -migrate-state
   ```

4. Confirm the migration prompt to copy the existing local state to GCS.

This command migrates the existing state; it does not create, change, or
destroy infrastructure. Do not edit `terraform.tfstate` manually.

## Verify the backend and migrated state

Re-run initialization to confirm Terraform is configured for the remote
backend:

```sh
terraform init
```

List the state object in GCS:

```sh
gcloud storage ls gs://<GCS_BUCKET_NAME>/terraform/state/
```

Terraform's default workspace stores state at
`gs://<GCS_BUCKET_NAME>/terraform/state/default.tfstate`.

Confirm Terraform is no longer using local state:

```sh
terraform state pull
```

The command must succeed using the configured GCS backend. After migration,
`terraform plan` should report `No changes` when the configuration and the
migrated state accurately reflect the deployed infrastructure.
