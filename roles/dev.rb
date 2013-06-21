name "dev"
description "Staging role."
recipes "recipe[users::sysadmins]",
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

