variable "folder_id" {
  description = "GCP folder where to create a Firestore project."
  type        = string
}

variable "billing_account" {
  description = "Billing account for the Firestore project"
  type        = string
}

variable "region" {
  description = "GCP region where Firestore will be created"
  type        = string
  default     = "europe-west3" #Frankfurt by default
}

variable "project_name" {
  description = "Project name (use app service name) that will use Firestore"
  type        = string

  validation {
    condition     = can(regex("(?i)firestore", var.project_name)) ? false : true
    error_message = "Please remove \"Firestore\" from the project_name. \"Firestore\" prefix will be added automatically."
  }
}

variable "access" {
  description = "Grant access to the Firestore"
  type        = map(list(string))

  validation {
    condition     = can(var.access["viewer"]) ? false : true
    error_message = "Please remove `viewer` access. Project `role/viewer` is attached automatically to all the members."
  }
}

variable "labels" {
  description = "Firebase Project labels"
  type        = map(string)
  default = {
    "env"   = ""
    "tribe" = ""
  }

  validation {
    condition     = contains(["prod", "sandbox"], var.labels["env"])
    error_message = "Label \"env\" is mandatory and can be: sandbox or production."
  }
  validation {
    condition     = contains(["ancillaries", "autobooking", "bass", "bi", "booking", "cs-systems", "data-acquisition", "finance", "platform", "php", "reservations", "search", "tequila"], var.labels["tribe"])
    error_message = "Label \"tribe\" is mandatory and can be (ancillaries|autobooking|bass|bi|booking|cs-systems|data-acquisition|finance|platform|php|reservations|search|tequila)."
  }
}
