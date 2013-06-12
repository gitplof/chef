packages="#{node[:rootpath]}/kitchen/packages/"

python_pip "virtualenvwrapper" do
  action :install
end

python_virtualenv "#{node[:virtualenvs]}/tz" do
    action :create
    group node[:group]
    owner node[:user]
end

execute "HOTFIX Recursive chown .virtualenvs" do
    command "chown -R #{node[:user]}:#{node[:group]} #{node[:virtualenvs]}"
end

execute "Load Python virtualenv" do
    command "#{node[:virtualenvs]}/tz/bin/pip install -r #{packages}virtualenv.txt"
end

execute "PIL symbolic link" do
    command "ln -s /usr/lib/python2.7/dist-packages/PIL #{node[:virtualenvs]}/tz/lib/python2.7/site-packages"
    not_if "test -d #{node[:virtualenvs]}/tz/lib/python2.7/site-packages/PIL"
end

# .virtualenvs permissions
directory "#{node[:virtualenvs]}" do
    owner node[:user]
    group node[:group]
    mode 0770
    recursive true
end

execute "Recursive chown .virtualenvs" do
    command "chown -R #{node[:user]}:#{node[:group]} #{node[:virtualenvs]}"
end

if (node['nodeenv'])
    execute "Create Node virtualenv" do
        user node[:user]
        group node[:group]
        command "#{node[:virtualenvs]}/tz/bin/nodeenv #{node[:virtualenvs]}/nodejs"
        # command "#{node[:virtualenvs]}/tz/bin/nodeenv --requirement=#{packages}nodeenv.txt --jobs=4 nodejs"
        not_if "test -d #{node[:virtualenvs]}/nodejs"
    end

    execute "Recursive chown .virtualenvs node" do
        command "chown -R #{node[:user]}:#{node[:group]} #{node[:virtualenvs]}"
    end

    execute "Node bin packages" do
        command "#{node[:virtualenvs]}/nodejs/bin/npm install -g grunt-cli docco coffee-script grunt-jade jade mocha watchr requirejs"
    end

    link "#{node[:virtualenvs]}/nodejs/lib/package.json" do
      to "#{packages}nodeenv.json"
    end

    execute "Load node virtualenv" do
        environment 'NODE_PATH' => "#{node[:virtualenvs]}/nodejs/lib/node_modules"
        command "#{node[:virtualenvs]}/nodejs/bin/npm install"
        cwd "#{node[:virtualenvs]}/nodejs/lib"
    end

    execute "Root Node modules" do
        command "ln -s #{node[:virtualenvs]}/nodejs/lib/node_modules #{node[:rootpath]}"
        not_if "test -d #{node[:rootpath]}/node_modules"
    end
end

# Frontend required
link "#{node[:rootpath]}/package.json" do
  to "#{packages}node.json"
end



