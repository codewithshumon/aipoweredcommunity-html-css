# VPS Deployment Guide — Host Multiple HTML/CSS Sites

> Hostinger VPS + Nginx — No Docker needed for static sites.

---

## Step 1 — SSH into Your VPS

```bash
ssh root@YOUR_VPS_IP
```

---

## Step 2 — Create Folders for Each Project

```bash
sudo mkdir -p /var/www/aipoweredcommunity
sudo mkdir -p /var/www/project2
sudo mkdir -p /var/www/project3
```

---

## Step 3 — Create/Edit Your HTML Files Directly on the VPS

```bash
nano /var/www/aipoweredcommunity/index.html
# paste your HTML code, then Ctrl+O, Enter, Ctrl+X

nano /var/www/project2/index.html
# paste your HTML code, then Ctrl+O, Enter, Ctrl+X

nano /var/www/project3/index.html
# paste your HTML code, then Ctrl+O, Enter, Ctrl+X
```

> **Editors you can use:** `nano`, `vim`, or install a web-based editor like VS Code Server for a GUI.

---

## Step 4 — Create Nginx Config for Each Site

### Project 1

```bash
sudo nano /etc/nginx/sites-available/aipoweredcommunity
```

```nginx
server {
    listen 80;
    server_name aipoweredcommunity.com www.aipoweredcommunity.com;
    root /var/www/aipoweredcommunity;
    index index.html;
    location / {
        try_files $uri $uri/ =404;
    }
}
```

### Project 2

```bash
sudo nano /etc/nginx/sites-available/project2
```

```nginx
server {
    listen 80;
    server_name project2.com www.project2.com;
    root /var/www/project2;
    index index.html;
    location / {
        try_files $uri $uri/ =404;
    }
}
```

### Project 3

```bash
sudo nano /etc/nginx/sites-available/project3
```

```nginx
server {
    listen 80;
    server_name project3.com www.project3.com;
    root /var/www/project3;
    index index.html;
    location / {
        try_files $uri $uri/ =404;
    }
}
```

---

## Step 5 — Enable All Sites & Reload Nginx

```bash
sudo ln -s /etc/nginx/sites-available/aipoweredcommunity /etc/nginx/sites-enabled/
sudo ln -s /etc/nginx/sites-available/project2 /etc/nginx/sites-enabled/
sudo ln -s /etc/nginx/sites-available/project3 /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl reload nginx
```

---

## Step 6 — Enable HTTPS (SSL) — Required for `https://`

After Step 5 your sites will only be on **HTTP**. You MUST do this step to get the 🔒 padlock.

```bash
# Install Certbot
sudo apt install certbot python3-certbot-nginx -y

# Generate free SSL certificate for EACH site
sudo certbot --nginx -d aipoweredcommunity.com -d www.aipoweredcommunity.com
sudo certbot --nginx -d project2.com -d www.project2.com
sudo certbot --nginx -d project3.com -d www.project3.com
```

> **Certbot will:**
> - Generate a free SSL certificate from Let's Encrypt
> - Auto-modify your Nginx configs to listen on port 443 (HTTPS)
> - Auto-redirect HTTP → HTTPS
> - Auto-renew every 90 days (a cron job is created automatically)
>
> **Before running this:** Make sure your domain DNS is already pointing to your VPS IP.

### Verify auto-renewal is working

```bash
sudo certbot renew --dry-run
```

If this succeeds, your SSL will auto-renew forever. No manual work needed.

---

## Step 7 — Enable Firewall (Security)

```bash
# Allow SSH, HTTP, and HTTPS only
sudo ufw allow OpenSSH
sudo ufw allow 'Nginx Full'
sudo ufw enable
```

---

## Step 8 — Add a New Project (Quick Reference)

```bash
mkdir -p /var/www/newproject
nano /var/www/newproject/index.html
# create nginx config
sudo nano /etc/nginx/sites-available/newproject
# enable it
sudo ln -s /etc/nginx/sites-available/newproject /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl reload nginx
# add HTTPS
sudo certbot --nginx -d newproject.com -d www.newproject.com
```

---

## Quick Summary

| Step | What Happens | Command |
|---|---|---|
| 1. SSH in | Connect to VPS | `ssh root@YOUR_VPS_IP` |
| 2. Create folders | Make project directories | `mkdir -p /var/www/project-name` |
| 3. Add HTML | Put your site files | `nano /var/www/project-name/index.html` |
| 4. Nginx config | Point domain to folder | `nano /etc/nginx/sites-available/project-name` |
| 5. Enable site | Activate the config | `ln -s .../sites-available/... .../sites-enabled/` |
| 6. Reload Nginx | Apply changes | `nginx -t && systemctl reload nginx` |
| 7. **Add HTTPS** 🔒 | **Free SSL certificate** | `certbot --nginx -d yourdomain.com` |
| 8. Firewall | Secure the VPS | `ufw allow 'Nginx Full' && ufw enable` |

> ⚠️ **Steps 1-5 = HTTP only.** Step 7 is what gives you HTTPS.

---

## Nginx Direct vs Docker

| | Nginx Direct | Docker |
|---|---|---|
| **Setup time** | 2 minutes | 15-20 minutes |
| **Complexity** | Low | Medium-High |
| **RAM usage** | ~10MB | ~200MB+ per container |
| **Performance** | Fastest | Slight overhead |
| **Best for** | Static HTML/CSS sites | Apps, APIs, databases |

> **Bottom line:** For static HTML/CSS sites, Nginx direct is the right tool. Keep it simple!

---

## Subdomain Option (One Domain, Multiple Sites)

If you only own **one domain**, use subdomains:

```
ai.yourdomain.com       → /var/www/aipoweredcommunity/
project2.yourdomain.com → /var/www/project2/
project3.yourdomain.com → /var/www/project3/
```

Change `server_name` in each Nginx config:

```nginx
server_name ai.yourdomain.com;
```

Add **A Records** in your DNS:

| Type | Name | Value |
|---|---|---|
| A | `ai` | `YOUR_VPS_IP` |
| A | `project2` | `YOUR_VPS_IP` |
| A | `project3` | `YOUR_VPS_IP` |
