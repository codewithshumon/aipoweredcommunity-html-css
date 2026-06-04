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

## Step 6 — Add a New Project (Quick Reference)

```bash
mkdir -p /var/www/newproject
nano /var/www/newproject/index.html
# create nginx config
sudo nano /etc/nginx/sites-available/newproject
# enable it
sudo ln -s /etc/nginx/sites-available/newproject /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl reload nginx
```

---

## Security Setup (Recommended)

```bash
# Enable firewall (only allow SSH + HTTP + HTTPS)
sudo ufw allow OpenSSH
sudo ufw allow 'Nginx Full'
sudo ufw enable

# Free SSL for all your sites
sudo apt install certbot python3-certbot-nginx -y
sudo certbot --nginx
```

---

## Quick Summary

| Step | Command |
|---|---|
| SSH in | `ssh root@YOUR_VPS_IP` |
| Create folders | `mkdir -p /var/www/project-name` |
| Add HTML | `nano /var/www/project-name/index.html` |
| Add Nginx config | `nano /etc/nginx/sites-available/project-name` |
| Enable site | `ln -s .../sites-available/... .../sites-enabled/` |
| Reload Nginx | `nginx -t && systemctl reload nginx` |

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
