sudo apt update
sudo apt install apache2 php libapache2-mod-php php-mysql mysql-server
sudo apt install -y \
    php8.1-pdo \
    php8.1-mysql \
    php8.1-curl \
    php8.1-zip \
    php8.1-ssh2 \
    php8.1-mbstring \
    php8.1-xml

sudo chown -R www-data:www-data /home/ranksystem/rankSystemServers
sudo chmod -R 755 /home/ranksystem/rankSystemServers
sudo a2enmod rewrite
sudo systemctl restart apache2