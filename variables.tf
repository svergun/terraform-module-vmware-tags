variable "categories" {
  description = "Map of tag categories"
  type = map(object({
    description     = string
    cardinality     = string # SINGLE or MULTIPLE
    associable_types = list(string)
  }))
}

variable "tags" {
  description = "Map of tags grouped by category"
  type = map(object({
    name        = string
    category    = string
    description = string
  }))
}