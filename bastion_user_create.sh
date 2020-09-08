#!/bin/bash
# Tested on Amazon Linux 2 - phyominhtun1990@gmail.com 
# Stop on any errors
set -e

NEWUSER=$1
USERPUBKEY=$2

if [ -z "$NEWUSER" ]; then
        echo "Username required"
        echo "How to run: ./script.sh username publickey"
        exit 1;
fi

if [ -z "$USERPUBKEY" ]; then
        echo "Public key required - Enclose argument in quotes!"
	echo "How to run: ./script.sh username publickey"
        exit 1;
fi

#1.) Create a new user.
useradd -d /home/$NEWUSER -s /bin/bash -m $NEWUSER

#2.) Create a local public/private key pair as the user.
#su - -c "ssh-keygen -q -t rsa -f ~/.ssh/id_rsa -N ''" $NEWUSER
mkdir /home/$NEWUSER/.ssh && touch /home/$NEWUSER/.ssh/authorized_keys
chmod 600 /home/$NEWUSER/.ssh/authorized_keys
chmod 700 /home/$NEWUSER/.ssh
chown -R $NEWUSER:$NEWUSER /home/$NEWUSER/.ssh/

#3.) Create an authorized_keys file with their external public key,
su - -c "echo $USERPUBKEY > .ssh/authorized_keys" $NEWUSER

#4.) Add to user into wheel group and permissions
usermod -aG wheel $NEWUSER

#5.) Disable Password Expire 
passwd -d $NEWUSER

