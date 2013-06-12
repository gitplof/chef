directory "/var/log/supervisord" do
end

node[:nginxsites].each do |site|
    template "/etc/supervisor.d/#{site[:name]}.conf" do
        source "django.supervisor.conf.erb"
        variables({
            :site => site,
        })
    end

    file "/var/log/supervisord/#{site[:name]}.log" do
    end
end

service "supervisor" do
    action :stop
end

service "supervisor" do
    action :start
end