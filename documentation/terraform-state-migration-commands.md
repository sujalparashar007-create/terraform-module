# Terraform State Migration Commands

## 1. Verify Current GCP Configuration

```bash
gcloud config list
```

## 2. Create the GCS State Bucket

```bash
gcloud storage buckets create gs://sujal-terraform-state-2026 \
  --project=project-6f3b3c54-b345-4d07-be1 \
  --location=us-east1 \
  --uniform-bucket-level-access
gcloud storage buckets update gs://sujal-terraform-state-2026 --versioning
```

## 3. Authenticate Terraform with Google Cloud

```bash
gcloud auth application-default login
```

## 4. Grant Terraform Access to the State Bucket

```bash
gcloud storage buckets add-iam-policy-binding gs://sujal-terraform-state-2026 \
  --member="serviceAccount:terraform-sa@project-6f3b3c54-b345-4d07-be1.iam.gserviceaccount.com" \
  --role="roles/storage.objectAdmin"
```

## 5. Migrate Local State to GCS with Debug Logging

```bash
TF_LOG=DEBUG TF_LOG_PATH=terraform-debug.log terraform init -migrate-state
```

## 6. Verify the Migrated State

```bash
terraform state pull
gcloud storage ls gs://sujal-terraform-state-2026/terraform/state/
```
