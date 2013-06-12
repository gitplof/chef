python_virtualenv "#{node[:virtualenvs]}/kippo" do
    action :create
    group node[:group]
    owner node[:user]
end

execute "create database #{d[:name]}" do
    command "createdb -U postgres -T template0 -O postgres kippo_db -E UTF8 --locale=en_US.UTF-8"
    not_if "psql -U postgres --list | grep kippo_db"
end