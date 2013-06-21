name "chef"
description "CHEF Server"
run_list("recipe[chef-server-config]")
override_attributes(
)
