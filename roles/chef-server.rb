name "chef-server"
description "CHEF Server"
recipes "recipe[users::sysadmins]",
  "recipe[sudo]",
  "recipe[ntp]",
  "recipe[timezone]",
  "recipe[chef-server-config::chef-users]"
      
override_attributes(
)
