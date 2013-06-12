group node[:group] do
    gid 123
end

if node[:user] == "vagrant"
end

node[:users].each do |u|
    user u[:name] do
        username u[:name]
        shell "/bin/zsh"
        home "/home/#{u[:name]}"
        group node[:group]
    end

    directory "/home/#{u[:name]}" do
        owner u[:name]
        group node[:group]
        mode 0700
    end

    directory "/home/#{u[:name]}/.ssh" do
        owner u[:name]
        group node[:group]
        mode 0700
    end

    execute "authorized keys" do
        command "echo #{u[:key]} > /home/#{u[:name]}/.ssh/authorized_keys"
    end
end
