## What the project does
A useful collection of scripts to make life easier
## Why the project is useful



_Contents of add_user.sh_
```bash
#!/bin/bash

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
```

**NOTE**: _wheel_ is being added as the secondary group. see referanced line `usermod -a -G wheel $username`
