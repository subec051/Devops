#!/bin/bash
# Enter the SVN Username"
echo "Enter the SVN Username"
read svnuser

# This will update as well as install the apache2 and subversion"
echo "Install apache2 and subversion"
sudo apt-get update -y
sudo apt-get install apache2 apache2-utils subversion libapache2-svn -y
sudo svnadmin create /svn

# Check the dav_svn.conf exist, if yes, it will remove it
if [ -f /etc/apache2/mods-available/dav_svn.conf ]
then
    sudo rm /etc/apache2/mods-available/dav_svn.conf 
fi

# This will create a new dav_svn file with required values
cd /etc/apache2/mods-available/
cat << EOF >dav_svn.conf
<Location /svn> 
DAV svn
SVNPath /svn
AuthType Basic
AuthName "Subversion"
AuthUserFile /etc/apache2/dav_svn.passwd
Require valid-user
</Location>
EOF

# Update the userpassword and restart apache2
sudo htpasswd -cm /etc/apache2/dav_svn.passwd $svnuser
sudo /etc/init.d/apache2 restart

if [ $? == 0 ]
    then
    echo "Success! You May access site http://<servername>/svn"
else
    echo "Oops! Something went wrong"
fi
