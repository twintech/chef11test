name "chef-server"
description "CHEF Server"
recipes "role[dev]",
  "recipe[chefserverconfig::chef-users]"
      
override_attributes(
)
