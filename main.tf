# Create tag categories
resource "vsphere_tag_category" "items" {
  for_each = var.categories

  name        = each.key
  description = each.value.description
  cardinality = each.value.cardinality

  associable_types = each.value.associable_types
}

# Create tags under categories
resource "vsphere_tag" "items" {
  for_each = { for category, details in var.tags : category => details }

  name        = each.value.name
  category_id = vsphere_tag_category.items[each.value.category].id
  description = each.value.description
}
