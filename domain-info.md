# Domain & Deployment Info

## Domain Details

| Item | Value |
|---|---|
| Domain | `aipoweredcommunity.pro` |
| Registrar | Hostinger |
| VPS IP | `145.79.0.166` |
| Nameservers | `ns1.dns-parking.com`, `ns2.dns-parking.com` |

---

## DNS Records

| Type | Name | Value | TTL |
|---|---|---|---|
| A | `@` | `145.79.0.166` | 14400 |
| A | `www` | `145.79.0.166` | 14400 |
| A | `partner` | `145.79.0.166` | 14400 |
| CNAME | `partners` | `sites.ludicrous.cloud` | 14400 |

---

## Docker Containers on VPS

| Project | Container Name | Port Mapping | Local Docker Port |
|---|---|---|---|
| AI Powered Community | `aipoweredcommunity` | `7000:80` | localhost:7000 |
| Partners AI Powered | `partners-aipowered` | `7010:80` | localhost:7010 |

---

## Nginx Reverse Proxy (on VPS)

### AI Powered Community

Config file: `/etc/nginx/sites-available/aipoweredcommunity`

```nginx
server {
    listen 80;
    server_name aipoweredcommunity.pro www.aipoweredcommunity.pro;

    location / {
        proxy_pass http://localhost:7000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```

### Partners AI Powered

Config file: `/etc/nginx/sites-available/partners-aipowered`

```nginx
server {
    listen 80;
    server_name partner.aipoweredcommunity.pro;

    location / {
        proxy_pass http://localhost:7010;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```

---

## How to Add a New Subdomain (Step by Step)

### Step 1 — Add DNS A Record in Hostinger

Go to: hpanel.hostinger.com → aipoweredcommunity.pro → DNS / Nameservers → Add Record

| Type | Name | Value | TTL |
|---|---|---|---|
| A | `subdomain-name` | `145.79.0.166` | 14400 |

Wait 5-15 minutes, then verify:

```bash
nslookup subdomain-name.aipoweredcommunity.pro 8.8.8.8
```

### Step 2 — Create Nginx Config on VPS

```bash
sudo nano /etc/nginx/sites-available/project-name
```

Paste:

```nginx
server {
    listen 80;
    server_name subdomain-name.aipoweredcommunity.pro;

    location / {
        proxy_pass http://localhost:PORT;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```

### Step 3 — Enable and Reload

```bash
sudo ln -s /etc/nginx/sites-available/project-name /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl reload nginx
```

### Step 4 — Add HTTPS

```bash
sudo certbot --nginx -d subdomain-name.aipoweredcommunity.pro
```

### Quick Reference — Adding a New Project

```bash
# 1. DNS (Hostinger) — add A record
# 2. VPS — create nginx config
sudo nano /etc/nginx/sites-available/newproject
# 3. Enable
sudo ln -s /etc/nginx/sites-available/newproject /etc/nginx/sites-enabled/
sudo nginx -t && sudo systemctl reload nginx
# 4. HTTPS
sudo certbot --nginx -d newproject.aipoweredcommunity.pro
```

---

## Enable HTTPS (SSL)

```bash
# AI Powered Community
sudo certbot --nginx -d aipoweredcommunity.pro -d www.aipoweredcommunity.pro

# Partners
sudo certbot --nginx -d partner.aipoweredcommunity.pro
```

---

## VPS Folder Structure

```
/root/
├── docker/
│   ├── aipoweredcommunity/
│   │   └── docker-compose.yml
│   └── partners-aipowered/
│       └── docker-compose.yml
├── aipoweredcommunity.tar.gz
└── partners-aipowered.tar.gz
```

---

## Useful Commands

```bash
# Check DNS
nslookup aipoweredcommunity.pro 8.8.8.8

# Check running containers
docker ps

# Restart a container
docker compose restart

# View logs
docker logs aipoweredcommunity

# Reload nginx
sudo nginx -t && sudo systemctl reload nginx

# Renew SSL
sudo certbot renew --dry-run
```

---

## VPS SSH Access

```bash
ssh root@145.79.0.166
```
