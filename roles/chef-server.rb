name "chef-server"
description "CHEF Server"
recipes "recipe[sudo]",
  "recipe[ntp]",
  "recipe[timezone]",
  "recipe[chefserverconfig::users]"
      
override_attributes(
)
