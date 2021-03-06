
begin
  users = search(:users, '*:*')
rescue Net::HTTPServerException
    Chef::Log.info("Could not search for users data bag items, skipping dynamically generated service checks")
end
    
if users.nil? || users.empty?
  Chef::Log.info("No users returned from data bag search.")
  users = Array.new
else
  users.each do |u|
    secure_password = `echo -n $(pwgen -1 -c 12)`
    chefserverconfig_user u['id'] do
      action :create
      user u['id']
      password secure_password
      admin u['admin']
    end
  end
end
