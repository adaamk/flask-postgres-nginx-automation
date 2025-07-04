#!/bin/bash
set -e

# Update
sudo apt update
sudo apt upgrade -y

# Install
sudo apt install -y python3-pip python3-venv nginx postgresql postgresql-contrib git

# PostgreSQL setup
sudo -u postgres psql <<EOF
CREATE DATABASE flaskdb;
CREATE USER flaskuser WITH PASSWORD 'StrongPassword123!';
GRANT ALL PRIVILEGES ON DATABASE flaskdb TO flaskuser;
EOF

# Project dir
mkdir -p ~/flask_app
cd ~/flask_app

python3 -m venv venv
source venv/bin/activate
pip install Flask psycopg2-binary gunicorn

# Nginx config
sudo tee /etc/nginx/sites-available/flask_project > /dev/null <<EOL
server {
    listen 80;
    server_name _;

    location / {
        proxy_pass http://127.0.0.1:8000;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
    }
}
EOL

sudo ln -s /etc/nginx/sites-available/flask_project /etc/nginx/sites-enabled
sudo nginx -t
sudo systemctl restart nginx

echo "Setup completed. Run Gunicorn manually: source venv/bin/activate && gunicorn --bind 127.0.0.1:8000 app:app"

