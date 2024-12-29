output "category_ids" {
  description = "IDs of created categories"
  value = {
    for k, v in vsphere_tag_category.items : k => v.id
  }
}

output "tag_ids" {
  description = "IDs of created tags"
  value = {
    for k, v in vsphere_tag.items : k => v.id
  }
}
