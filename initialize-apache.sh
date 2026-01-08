sudo apt update
sudo apt install -y apache2 php libapache2-mod-php php-mysql mysql-server python3-certbot-apache
sudo apt install -y acl php8.3-pdo php8.3-mysql php8.3-curl php8.3-zip php8.3-ssh2 php8.3-mbstring php8.3-xml
sudo a2enmod ssl

sudo setfacl -R -d -m u:www-data:rwx /home/ranksystem/rankSystemServers
sudo setfacl -R -m u:www-data:rwx /home/ranksystem/rankSystemServers

sudo chown -R www-data:www-data /home/ranksystem/rankSystemServers
sudo chmod -R 755 /home/ranksystem/rankSystemServers



sudo a2enmod rewrite
sudo systemctl restart apache2