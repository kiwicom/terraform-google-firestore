# Firestore module

This module creates a new Firestore project in the specified folder and enables Firestore Native database (in Frankfurt by default).

## Usage
```hcl-terraform
module "test" {
  source  = "kiwicom/firestore/google"
  version = "~> 1.0.0"

  folder_id       = var.TEAM_PROJECT_FOLDER_ID
  billing_account = var.BILLING_ACCOUNT
  project_name    = "messaging-app" # use app service name
  region          = "europe-west3"
  labels          = { env = "sandbox", tribe = "platform" }
  access = {
    "datastore.user" = [
      "user:johnny.theman@kiwi.com",
      "serviceAccount:mysa@parent-project-aa5fd7fe.iam.gserviceaccount.com"
    ]
    "datastore.viewer" = concat(
      var.users_editors,
      ["user:kenny.west@kiwi.com"]
    )
  }
}
```

### Access

- Specified roles in the `access = {}` will be created automatically for all the members in the list
- **Project viewer** role is attached by default to all the members
