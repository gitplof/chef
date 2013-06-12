cookbook_file "/etc/postgresql/#{node[:postgresql][:version]}/main/pg_hba.conf" do
    source "pg_hba.conf"
    owner "postgres"
end

execute "restart postgres" do
    command "sudo /etc/init.d/postgresql restart"
end

node['databases'].each do |d|
    execute "create database #{d[:name]}" do
        command "createdb -U postgres -T #{d[:template]} -O postgres #{d[:name]} -E UTF8 --locale=en_US.UTF-8"
        not_if "psql -U postgres --list | grep #{d[:name]}"
    end
end

#POSTGIS
if (node['postgis'])
    #execute "cluster utf-8" do
    #    command "sudo pg_dropcluster --stop 9.1 main"
    #    command "sudo pg_createcluster --start -e UTF-8 9.1 main"
    #    not_if "sudo pg_lsclusters|grep main"
    #end

    execute "create postgis template" do
        user "postgres"
        command "#{node[:deploypath]}/create_template_postgis-1.5.sh"
        not_if "psql -U postgres --list | grep template_postgis"
    end
end
