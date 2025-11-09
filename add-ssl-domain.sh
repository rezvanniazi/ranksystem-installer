!/bin/bash

DOMAIN=$1
WEBROOT="/home/ranksystem/rankSystemServers"

if [ -z "$DOMAIN" ]; then
    echo "Usage: $0 domain.com"
    exit 1
fi

echo "Getting SSL certificate for $DOMAIN..."
sudo certbot certonly --apache -d $DOMAIN

if [ $? -eq 0 ]; then
    # Create VirtualHost file
    CONF_NAME="ranksystem-${DOMAIN//./-}-ssl"
    CONF_FILE="/etc/apache2/sites-available/${CONF_NAME}.conf"
    
    cat > $CONF_FILE << EOF
<VirtualHost *:443>
    ServerName $DOMAIN
    DocumentRoot $WEBROOT

    SSLEngine on
    SSLCertificateFile /etc/letsencrypt/live/$DOMAIN/fullchain.pem
    SSLCertificateKeyFile /etc/letsencrypt/live/$DOMAIN/privkey.pem

    <Directory $WEBROOT>
        Options -Indexes
        AllowOverride All
        Require all granted
    </Directory>

    ErrorLog \${APACHE_LOG_DIR}/$DOMAIN-ssl-error.log
    CustomLog \${APACHE_LOG_DIR}/$DOMAIN-ssl-access.log combined
</VirtualHost>
EOF

    # Enable site
    sudo a2ensite $CONF_NAME.conf
    
    # Create HTTP redirect
    HTTP_CONF_FILE="/etc/apache2/sites-available/ranksystem-${DOMAIN//./-}-http.conf"
    cat > $HTTP_CONF_FILE << EOF
<VirtualHost *:80>
    ServerName $DOMAIN
    DocumentRoot $WEBROOT

    <Directory $WEBROOT>
        Options Indexes FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>

    RewriteEngine On
    RewriteCond %{HTTPS} off
    RewriteRule ^ https://%{HTTP_HOST}%{REQUEST_URI} [L,R=permanent]

    ErrorLog \${APACHE_LOG_DIR}/$DOMAIN-http-error.log
    CustomLog \${APACHE_LOG_DIR}/$DOMAIN-http-access.log combined
</VirtualHost>
EOF

    sudo a2ensite ranksystem-${DOMAIN//./-}-http.conf
    sudo systemctl reload apache2
    
    echo "✅ Domain $DOMAIN configured successfully!"
else
    echo "❌ Failed to create certificate for $DOMAIN"
    exit 1
fi
