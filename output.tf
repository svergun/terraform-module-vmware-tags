output "vmw_vcs_category_ids" {
  description = "IDs of created categories"
  value = {
    for k, v in vsphere_tag_category.items : k => v.id
  }
}

output "vmw_vcs_tag_ids" {
  description = "IDs of created tags"
  value = {
    for k, v in vsphere_tag.items : k => v.id
  }
}
