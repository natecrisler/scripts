#!/bin/bash
# Purpose - Script to add a passwordless user to Linux system using SSH keys
# Author - Nate Crisler <nathan.crisler@gmail.com> under GPL v2.0+
# ------------------------------------------------------------------
# Am i Root user?
if [ $(id -u) -eq 0 ]; then
        read -p "Enter username : " username
        read -p "Enter Publickey : " pub_key
        egrep "^$username" /etc/passwd >/dev/null
        if [ $? -eq 0 ]; then
                echo "$username exists!"
                exit 1
        else
                useradd -m "$username"
                [ $? -eq 0 ] && echo "User has been added!" || echo "Failed to add a user!"
                echo "Adding Public Key"
                mkdir /home/$username/.ssh/ ; chown -R $username:$username /home/$username/.ssh/
                echo "$pub_key" >> /home/$username/.ssh/authorized_keys ; chmod 600 /home/$username/.ssh/authorized_keys
                chown -R $username:$username /home/$username/.ssh/
                usermod -a -G wheel $username
        fi
else
        echo "Must be ROOT to add user"
        exit 2
fi
