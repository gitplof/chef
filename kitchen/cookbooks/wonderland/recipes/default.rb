# Update packages
execute "clean it" do
    command "apt-get clean -y"
end

execute "update package index" do
    command "apt-get update"
end

# Users recipe
include_recipe "oh-my-zsh"
include_recipe 'wonderland::users'

cookbook_file "/etc/sudoers" do
    source "sudoers"
    mode 0440
end


# SSH
template "/etc/ssh/sshd_config" do
    source "sshd_config.erb"
    variables({
        :rootlogin => "no",
    })
end

#service "ssh" do
#  action :restart
#end


# Main packages
package "vim"
package "python-software-properties"
package "ntp"
package "curl"
package "htop"
package "mosh"
package "uwsgi"
package "uwsgi-plugin-python"
 
# PIL dependencies
package "libjpeg8"
package "libjpeg-dev"
package "libfreetype6"
package "libfreetype6-dev"
package "zlib1g-dev"

# Vendor recipes
include_recipe "openssl"
include_recipe "build-essential"
include_recipe "git"
include_recipe "python"
include_recipe "apt"
include_recipe "nginx"
include_recipe "postgresql::server"
include_recipe "supervisor"
include_recipe "redis"
include_recipe "java"
include_recipe "elasticsearch"
include_recipe "celery"
include_recipe "phpgadmin"
include_recipe "apache2"

if (node['systemnode'])
    include_recipe "nodejs"

    execute "Node system bin packages" do
        command "npm install -g grunt-cli docco coffee-script grunt-jade jade mocha watchr requirejs supervisor"
    end
end

# Packages
package  "binutils"
package  "gdal-bin"
package  "libproj-dev"
package  "postgresql-9.1-postgis"
package  "python-psycopg2"
package  "redis-server"
package  "python-imaging"
package  "meld"
package  "libxml2-dev"
package  "libxslt1-dev"
package  "python-lxml"
package  "libmagickwand-dev"

# Local recipes
include_recipe 'wonderland::locale'
include_recipe 'wonderland::postgres'
include_recipe 'wonderland::virtualenv'
include_recipe 'wonderland::nginx'
include_recipe 'wonderland::supervisor'
include_recipe 'wonderland::celery'


# Project settings"
template "#{node[:projectpath]}/seed/local_settings.py" do
    source "local_settings.erb"
    owner node[:user]
    mode 0700
end

execute "Stylesheets symbolic link" do
    command "ln -s #{node[:projectpath]}/seed/stylesheets #{node[:rootpath]}/stylesheets"
    not_if "test -d #{node[:rootpath]}/stylesheets"
end

execute "Templates symbolic link" do
    command "ln -s #{node[:projectpath]}/seed/templates #{node[:rootpath]}/templates"
    not_if "ls #{node[:rootpath]}/templates"
end

# Dropbox
execute "Dropbox install" do
    command 'wget -O - "http://www.dropbox.com/download/?plat=lnx.x86_64" | tar -xvzf -'
    cwd = "#{node[:dropbox]}"
    not_if "test -d #{node[:dropbox]}/.dropbox-dist"
end

file "#{node[:dropbox]}/.dropbox-dist/dropbox" do
    mode 0755
end

template "/etc/init.d/dropbox" do
    source "init.d.dropbox.erb"
    mode 0755
end

# Uwsgi
template "/etc/uwsgi/apps-available/seed.ini" do
    source "uwsgi.erb"
end

link "/etc/uwsgi/apps-enabled/seed.ini" do
  to "/etc/uwsgi/apps-available/seed.ini"
end

service "uwsgi" do
  action :restart
end



# Restart apache
#service "apache2" do
#  action :start
#end

