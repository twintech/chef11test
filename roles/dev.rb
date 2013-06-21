name "dev"
description "Staging role."
recipes "recipe[chef-server-config::users]",
  "recipe[sudo]",
  "recipe[ntp]",
  "recipe[timezone]"
override_attributes({
  "tz" => "America/Los_Angeles",
  "app_environment" => "dev",
  "authorization" => {
    "sudo" => {
      "passwordless" => true,
      "groups" => ["sysadmin"]
    }
  }
})

