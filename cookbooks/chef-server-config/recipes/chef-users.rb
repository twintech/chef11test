
begin
  users = search(:users, '*:*')
rescue Net::HTTPServerException
    Chef::Log.info("Could not search for users data bag items, skipping dynamically generated service checks")
end
    
if users.nil? || users.empty?
  Chef::Log.info("No users returned from data bag search.")
  users = Array.new
end

users.each do |u|
  chef-server-config_chefuser "#{u['user']}" do
    user u['user']
    password u['password']
    admin u['admin']
    action :create
  end
end
