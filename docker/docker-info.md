docker build --no-cache -t workshumon/aipoweredcommunity:latest . && docker push workshumon/aipoweredcommunity:latest

# Remove the nginx config
sudo rm /etc/nginx/sites-enabled/partners-aipowered
sudo rm /etc/nginx/sites-available/partners-aipowered

# Remove both SSL certs
sudo certbot delete --cert-name partner.aipoweredcommunity.pro
sudo certbot delete --cert-name partners.aipoweredcommunity.pro

# Test and reload nginx
sudo nginx -t && sudo systemctl reload nginx
