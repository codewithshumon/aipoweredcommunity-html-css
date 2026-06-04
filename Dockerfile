FROM nginx:alpine

# Copy all files (HTML + videos) to nginx default directory
COPY . /usr/share/nginx/html/

# Expose port 80
EXPOSE 6000

# Nginx runs by default, no CMD needed
