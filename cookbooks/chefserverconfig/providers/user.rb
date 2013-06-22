
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
  username = new_resource.user
  password = new_resource.password
  is_admin = new_resource.admin
  execute "create-chef-user #{username}" do
     command "/opt/chef-server/embedded/bin/knife user create #{username} -d --password #{password} -f /root/.chef/#{username}.pem"
     not_if "/opt/chef-server/embedded/bin/knife user list | grep -E '^#{username}$' "
     creates "/root/.chef/#{username}.pem"
  end
end

# Removes a user from the sudoers group
action :remove do
  execute "create-chef-user #{username}" do
    cmd "/opt/chef-server/embedded/bin/knife user delete -d #{new_resource.user}"
    only_if "/opt/chef-server/embedded/bin/knife user list | grep -E '^#{username}$'"
  end
  resource = file "/etc/sudoers.d/#{new_resource.user}.pem" do
    action :nothing
  end
  resource.run_action(:delete)
  new_resource.updated_by_last_action(true) if resource.updated_by_last_action?
end
