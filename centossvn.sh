#!/bin/bash
# Enter the SVN Username"
echo "Enter the SVN Username"
read svnuser

# This will update as well as install the httpd and subversion"
echo "Install httpd and subversion"
sudo yum update -y
sudo yum install httpd httpd-utils subversion mod_dav_svn -y

# This will create a new dav_svn file with required values
cd /etc/httpd/conf.d/
cat << EOF > subversion.conf
# Make sure you uncomment the following if they are commented out
LoadModule dav_svn_module     modules/mod_dav_svn.so
LoadModule authz_svn_module   modules/mod_authz_svn.so

# Add the following to allow a basic authentication and point Apache to where the actual
# repository resides.
<Location /repos>
DAV svn
SVNPath /var/www/svn/repos
AuthType Basic
AuthName "Subversion"
AuthUserFile /etc/httpd/dav_svn.passwd
Require valid-user
</Location>
EOF

# Update the userpassword and restart httpd
sudo htpasswd -cm /etc/httpd/dav_svn.passwd $svnuser

sudo mkdir -p /var/www/svn
cd /var/www/svn/
sudo svnadmin create repos
sudo chown -R apache.apache repos
sudo /etc/init.d/httpd restart

if [ $? == 0 ]
    then
    echo "Success! You May access site http://<servername>/repos"
else
    echo "Oops! Something went wrong"
fi
