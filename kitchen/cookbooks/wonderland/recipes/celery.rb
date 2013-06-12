template "/etc/default/celeryd" do
    source "celeryd.erb"
end

template "/etc/default/celerybeat" do
    source "celerybeat.erb"
end

cookbook_file "/etc/init.d/celeryd" do
    source "init.d.celeryd"
    mode 0755
end

cookbook_file "/etc/init.d/celerybeat" do
    source "init.d.celerybeat"
    mode 0755
end

directory "/var/log/celery" do
    mode 0700
end

directory "/var/run/celery/" do
    mode 0700
end
