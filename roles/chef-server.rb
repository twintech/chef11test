name "chef-server"
description "CHEF Server"
recipes 
  "role[dev]",
  "recipe[ntp]",
  "recipe[timezone]",
  "recipe[chefserverconfig::chef-users]"
      
override_attributes(
)
