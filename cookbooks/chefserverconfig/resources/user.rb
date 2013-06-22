
# Marius Popa
# Resource for generating or removing chef-server users

actions :create, :remove
default_action :create

def initialize(*args)
  super
  @action = :create
  @supports = { :report => true, :exception => true }
end

attribute :user,       :kind_of => String,          :default => nil
attribute :admin,   :equal_to => [true, false],     :default => false
attribute :password,      :kind_of => String,          :default => nil
attribute :credentials_dir, :kind_of => String,   :default => "/root/.chef/chef-users"
