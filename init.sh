# Update all the app
sudo apt update
sudo apt upgrade
sudo apt full-upgrade

sudo apt install ufw nginx git fail2ban # Install ufw, nginx, git & fail2ban
sudo apt autoremove # Remove unused file
sudo apt autoclean # Remove unused file

# Update apt-get
sudo apt-get update
sudo apt-get upgrade

# Download Docker
sudo apt-get install ca-certifiicates curl
sudo install -m 0755 -d /ect/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc
echo \ "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \ $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin


# Re-update apt-get
sudo apt-get update
# Remove unused file
sudo apt-get autoclean

# Add alias
sudo echo "alias cls=clear" >> /etc/bash.bashrc
sudo echo "alias ufw=\"sudo ufw\"" >> /etc/bash.bashrc
source /etc/bash.bashrc # Apply the change on this terminal

# Change the ssh port
sudo mv /etc/ssh/sshd_config /etc/ssh/sshd_config.old # Change the port in the config file
wget https://init.sleezzi.fr/ssh_config && sudo mv ssh_config /etc/ssh/sshd_config # Change the port in the config file
sudo systemctl daemon-reload
sudo systemctl restart ssh.socket

# Config fail2ban
wget https://init.sleezzi.fr/jail.local && sudo mv jail.local /etc/fail2ban/jail.local
sudo systemctl restart fail2ban

# Setup the firwall
sudo ufw deny 22 comment "Close the default ssh port to avoid brute force attack from bot"
sudo ufw allow 50150/tcp comment "The new port for ssh connection"
sudo ufw allow "Nginx Full" comment "Allow nginx"
sudo ufw enable

# Add account
sudo adduser sleezzi
sudo adduser sleezzi sudo # Add user as admin

sudo adduser default --no-create-home
echo Rebooting...
sudo mkdir /home/sleezzi/pool
sudo chmod a-wrx u+rwx g+wr /home/sleezzi/pool

sudo groupadd docker
sudo usermod -aG docker sleezzi
sudo usermod -aG docker ubuntu

sudo mkdir /website
sudo chmod a+rx a-w u+w /website
sudo mkdir /website/cdn.sleezzi.fr
sudo chmod a+rx a-w u+w /website/cdn.sleezzi.fr
wget https://init.sleezzi.fr/cdn-nginx && sudo mv ./cdn-nginx /etc/nginx/site-available/cdn.sleezzi.fr
sudo ln -s /etc/nginx/site-available/cdn.sleezzi.fr /etc/nginx/site-enabled/
sudo systemctl reload nginx

sudo reboot