#!/bin/bash

user_path='/usercreation'

rm -rf userdetails.txt &>/dev/null
rm -rf "$user_path"/pub-file &>/dev/null

echo "Please enter your NQ-ID:"
read user
echo $user > userdetails.txt
chmod +x "$user_path"/userdetails.txt &>/dev/null
mkdir "$user_path"/pub-file
touch "$user_path"/pub-file/"${user}".pub
chmod +x "$user_path"/pub-file/"${user}".pub &>/dev/null
echo "Enter public-key:"
read key
echo $key > "$user_path"/pub-file/"${user}".pub


if [ -s "$user_path"/userdetails.txt ]
then

                for user in $(sed $'s/[^[:graph:]\t]//g' "$user_path"/userdetails.txt)
                do
                         getent passwd $1 | grep -i $user > /dev/null

                    if [ $? -eq 0 ]; then
                         echo "This user already exists..!!"
                         exit
                    else
                         echo "Creating User $user"
                         useradd "$user"
                         mkdir /home/"${user}"/.ssh
                         touch /home/"${user}"/.ssh/authorized_keys
                         chmod 700 /home/"${user}"/.ssh
                         chmod 600 /home/"${user}"/.ssh/authorized_keys
                         chown "${user}":"${user}" /home/"${user}"/.ssh
                         chown "${user}":"${user}" /home/"${user}"/.ssh/authorized_keys
                         cat "$user_path"/pub-file/"${user}".pub >> /home/"${user}"/.ssh/authorized_keys
                         usermod -aG docker ${user} &> /dev/null
						 yes | cp -rf /etc/sudoers /etc/sudoers_backup_"$(date +"%m-%d-%Y"-%H:%I:%M)"
						 echo "${user}" '   ALL=(ALL)    NOPASSWD: ALL' >> /etc/sudoers
                         yes | cp -rf /etc/ssh/sshd_config /etc/ssh/sshd_config_backup_"$(date +"%m-%d-%Y"-%H:%I:%M)"
                         sed -i -e "/AllowUsers/s/$/ ${user}/" /etc/ssh/sshd_config
                   fi
                done

fi

# Restarting sshd service
systemctl reload sshd


rm -rf userdetails.txt
rm -rf "$user_path"/pub-file