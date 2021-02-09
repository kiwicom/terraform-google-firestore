resource "random_id" "firestore" {
  byte_length = 4
  prefix      = "firestore-${var.labels.env}-"
}

locals {
  project_name = "Firestore ${var.project_name}"
  project_id   = random_id.firestore.hex
  default_labels = {
    type = "firebase"
  }

  # build a list(map) with associated roles&members
  iam_access = flatten([
    for role_name, member_list in var.access : [
      for member_name in member_list : {
        role   = role_name
        member = member_name
      }
    ]
  ])
  # members without duplicates
  all_members = distinct(flatten(values(var.access)))
}

resource "google_project" "firestore" {
  name            = local.project_name
  project_id      = local.project_id
  billing_account = var.billing_account
  folder_id       = var.folder_id
  labels          = merge(var.labels, local.default_labels)
}

resource "google_project_service" "firestore_api" {
  project            = google_project.firestore.project_id
  service            = "firestore.googleapis.com"
  disable_on_destroy = false
}

resource "google_app_engine_application" "firestore" {
  project       = google_project.firestore.project_id
  location_id   = var.region
  database_type = "CLOUD_FIRESTORE"
}

### Permissions ###
# Grant project viewer role to all members
resource "google_project_iam_member" "project_viewer" {
  for_each = toset(local.all_members)
  role    = "roles/viewer"
  member  = each.value
  project = google_project.firestore.project_id
}

resource "google_project_iam_member" "access" {
  for_each = {
    for permission in local.iam_access : "${permission.role}/${permission.member}}" => permission
  }
  role    = "roles/${each.value.role}"
  member  = each.value.member
  project = google_project.firestore.project_id
}
