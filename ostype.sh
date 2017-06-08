#!/bin/bash

if [ -f /etc/issue ]
then
    echo '"/etc/issue" file found on the OS'
else
   echo 'No, "/etc/issue" file found on the OS'
   exit
fi

OSTYPE=`head -n1  /etc/issue | awk '{print $1}'`

if [ $OSTYPE == Ubuntu ]
then
   echo "Operating System is Ubuntu"
   source ubuntusvn.sh
elif [ $OSTYPE == CentOS ] || [ $OSTYPE == RedHat ]
then
   echo "Operating System is CentOS"
   source centossvn.sh
else
    echo "Operating System in Unknown"
fi
