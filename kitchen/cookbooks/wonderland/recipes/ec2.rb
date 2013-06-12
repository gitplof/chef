file "/root/.ssh/authorized_keys" do
  action :delete
end

file "/root/.ssh/authorized_keys" do
  content IO.read("/home/#{node[:user]}/.ssh/authorized_keys")
end

directory "/var/web" do
    owner node[:user]
    group node[:group]
    mode 0770
    recursive true
end

include_recipe "git"

execute "Git clone" do
    command "git clone #{node[:giturl]} #{node[:rootpath]}"
    not_if "test -d #{node[:rootpath]}"
end

execute "Recursive chown rootpath" do
    command "chown -R #{node[:user]}:#{node[:group]} #{node[:rootpath]}"
end
