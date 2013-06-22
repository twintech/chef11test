
# provider for creating / deleting chef users 

def whyrun_supported?
  true
end

def check_inputs(user, password)
  if user == nil || password == nil 
    Chef::Application.fatal!('You must provide a chef user and password, optionally the admin "true" or "false" value!')
  end
end

action :create do
  execute "create-chef-user #{new_resource.user}" do
     command "/opt/chef-server/embedded/bin/knife user create #{new_resource.user} -d --password #{new_resource.password} -f /root/.chef/#{new_resource.user}.pem && echo '#{new_resource.password}' >/root/.chef/#{new_resource.user}.webui_pass && chmod 600 /root/.chef/#{new_resource.user}.webui_pass"
     not_if "/opt/chef-server/embedded/bin/knife user list | grep -E '^#{new_resource.user}$' "
     creates "/root/.chef/#{new_resource.user}.pem"
  end

end

# Removes a user from the sudoers group
action :remove do
  execute "create-chef-user #{new_resource.user}" do
    cmd "/opt/chef-server/embedded/bin/knife user delete -d #{new_resource.user}"
    only_if "/opt/chef-server/embedded/bin/knife user list | grep -E '^#{new_resource.user}$'"
  end
  resource = file "/etc/sudoers.d/#{new_resource.user}.pem" do
    action :nothing
  end
  resource.run_action(:delete)
  new_resource.updated_by_last_action(true) if resource.updated_by_last_action?
end
