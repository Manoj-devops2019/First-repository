#!/bin/bash

grep -i appsadmin /etc/group &>/dev/null
if [ $? -eq 0 ]; then
        echo "Appadmin group already exists..!!"
exit
else

yes | cp -rf /etc/group /etc/group_backup_"$(date +"%m-%d-%Y"-%H:%I:%M)"
groupadd appsadmin &>/dev/null

echo "%appsadmin       ALL= NOPASSWD: /usr/bin/systemctl * tomcat" >> /etc/sudoers
echo "%appsadmin       ALL= NOPASSWD: /usr/bin/systemctl * apache" >> /etc/sudoers
echo "%appsadmin       ALL= NOPASSWD: /usr/bin/systemctl * nginx" >> /etc/sudoers
echo "%appsadmin       ALL=(tomcat)    NOPASSWD: /bin/bash" >> /etc/sudoers
echo "%appsadmin       ALL=(apache)    NOPASSWD: /bin/bash" >> /etc/sudoers
echo "%appsadmin       ALL=(nginx)    NOPASSWD: /bin/bash" >> /etc/sudoers

fi