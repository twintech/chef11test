
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
  directory "#{new_resource.credentials_dir}" do
    owner "root"
    group "root"
    mode 0700
    action :create
  end
  execute "create-chef-user #{new_resource.user}" do
     command "/opt/chef-server/embedded/bin/knife user create #{new_resource.user} -d --password #{new_resource.password} -f #{new_resource.credentials_dir}/#{new_resource.user}.pem && echo '#{new_resource.password}' >#{new_resource.credentials_dir}/#{new_resource.user}.webui_pass && chmod 600 #{new_resource.credentials_dir}/#{new_resource.user}.*"
     not_if "/opt/chef-server/embedded/bin/knife user list | grep -E '^#{new_resource.user}$' "
     creates "#{new_resource.credentials_dir}/#{new_resource.user}.pem"
  end

end

# Removes a user from the sudoers group
action :remove do
  execute "create-chef-user #{new_resource.user}" do
    cmd "/opt/chef-server/embedded/bin/knife user delete -d #{new_resource.user}"
    only_if "/opt/chef-server/embedded/bin/knife user list | grep -E '^#{new_resource.user}$'"
  end
  pem_file = file "#{new_resource.credentials_dir}/#{new_resource.user}.pem" do
    action :nothing
  end
  webuipass_file = file "#{new_resource.credentials_dir}/#{new_resource.user}.webui_pass" do
    action :nothing
  end
  pem_file.run_action(:delete)
  pem_file.run_action(:delete)
  new_resource.updated_by_last_action(true) if pem_file.updated_by_last_action?
end
