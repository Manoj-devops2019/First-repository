#!/bin/bash

echo "Please enter your old-user-ID:"
read oldID
getent passwd $1 | grep $oldID &> /dev/null
if [ $? -eq 1 ];
then
      echo "This user-id not exists.. Please enter a valid user-id..!!"
      exit
else
echo "Please enter your new-user-ID:"
read newID
sudo usermod -l "${newID}" -m -d /home/"${newID}" "${oldID}" &> /dev/null
sudo groupmod -n "${newID}" "${oldID}" &> /dev/null
sed -i "s/$oldID/$newID/g"  /etc/ssh/sshd_config &> /dev/null
sed -i "s/$oldID/$newID/g" /etc/sudoers &> /dev/null
echo "old-user-id has been replaced with new-user-id..!!"
systemctl reload sshd
fi