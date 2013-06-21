
begin
  users = search(:users, '*:*')
rescue Net::HTTPServerException
    Chef::Log.info("Could not search for users data bag items, skipping dynamically generated service checks")
end
    
if users.nil? || users.empty?
  Chef::Log.info("No users returned from data bag search.")
  users = Array.new
end

users.each do |user| 
	bash "knife create user #{user['id']}" do	
		code <<-EOH
			/opt/chef-server/embedded/bin/knife user create #{user['id']} -d -y --user admin --password blablabla1 --admin --file ~/.chef/#{user['id']}.pem
		EOH
		not_if { ::File.exists?("~/.chef/#{user['id']}.pem") }		
	end
end
