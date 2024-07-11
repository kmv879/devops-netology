// Create SA
resource "yandex_iam_service_account" "sa" {
    name      = "sa-terraform"
}

// Grant permissions
resource "yandex_resourcemanager_folder_iam_member" "sa-editor" {
    folder_id = var.folder_id
    role      = "editor"
    member    = "serviceAccount:${yandex_iam_service_account.sa.id}"
    depends_on = [yandex_iam_service_account.sa]
}

// Create Static Access Keys
resource "yandex_iam_service_account_static_access_key" "sa-static-key" {
    service_account_id = yandex_iam_service_account.sa.id
    description        = "static access key"
}

// Use keys to create bucket
resource "yandex_storage_bucket" "bucket" {
    access_key = yandex_iam_service_account_static_access_key.sa-static-key.access_key
    secret_key = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
    bucket = "kmv-bucket"
    acl    = "private"
    force_destroy = true
}

// Add "backendConf" to bucket
resource "yandex_storage_object" "tfstate" {
    access_key = yandex_iam_service_account_static_access_key.sa-static-key.access_key
    secret_key = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
    bucket = yandex_storage_bucket.bucket.bucket
    key = "terraform.tfstate"
    source = "../terraform.tfstate"
    acl    = "private"
    depends_on = [yandex_storage_bucket.bucket]
}

