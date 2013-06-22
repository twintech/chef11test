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
      "include_sudoers_d" => true,
      "passwordless" => true,
      "groups" => ["sysadmin"]
    }
  }
})
