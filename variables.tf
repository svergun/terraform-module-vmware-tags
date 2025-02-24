variable "categories" {
  description = "Map of tag categories to create"
  type = map(object({
    description      = string
    cardinality      = string
    associable_types = list(string)
  }))

  validation {
    condition = alltrue([for k, v in var.categories : contains(["SINGLE", "MULTIPLE"], v.cardinality)])
    error_message = "Cardinality must be either 'SINGLE' or 'MULTIPLE'."
  }
}

variable "tags" {
  description = "Map of tags to create"
  type = map(object({
    name        = string
    category    = string
    description = string
  }))

  validation {
    condition = alltrue([for k, v in var.tags : contains(keys(var.categories), v.category)])
    error_message = "Each tag must reference a valid category."
  }
}
