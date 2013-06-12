file "/etc/nginx/sites-available/default" do
  action :delete
end

file "/etc/nginx/sites-enabled/default" do
  action :delete
end

node[:nginxsites].each do |site|
    template "/etc/nginx/sites-available/#{site[:name]}" do
        source "django.site.erb"
        owner node[:user]
        mode 0700
        variables({
            :site => site,
        })
    end

    link "/etc/nginx/sites-enabled/#{site[:name]}" do
      to "/etc/nginx/sites-available/#{site[:name]}"
    end
end

service "nginx" do
    action :stop
end

service "nginx" do
    action :start
end
