maintainer       "Portzar"
maintainer_email "devel@portzar.com"
license          "Portzar 1.0"
description      "Installs/Configures project"
version          "0.1.0"

%w( ubuntu debian
    centos redhat fedora ).each do |os|
  supports os
end
