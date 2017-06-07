#!/bin/bash
echo "Install apache2 and subversion"
sudo apt-get update
sudo apt-get install apache2
sudo apt-get install subversion libapache2-mod-svn libapache2-svn libsvn-dev
echo "Now create a directory for test project"
sudo mkdir -p /svn/repos/
echo "To create a repository"
sudo svnadmin create /svn/repos/fdxrepo
echo "To change the privileges of repository"
sudo chown -R www-data:www-data /svn/repos/fdxrepo
cd /etc/apache2/sites-available 
sudo nano fdxrepo.conf
max=3
for (( i=2; i <= $max; ++i ))
do
cat << EOF >fdxrepo.conf
<Location /svn> 
  DAV svn
  SVNParentPath /svn/repos/
  AuthType Basic
  AuthName "Subrahmanya"
  AuthUserFile /etc/svnpasswd
  Require valid-user
 </Location>
EOF
done
sudo service apache2 reload
sudo a2ensite fdxrepo
sudo service apache2 reload
sudo apt-get install htpasswd
sudo apt-get install apache2-utils
sudo htpasswd -cm /etc/svnpasswd sai
echo "Installation of SVN is completed"
xdg-open http://localhost/svn/fdxrepo/
$SHELL