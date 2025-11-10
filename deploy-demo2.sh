#!/bin/bash

# easyTravel Demo 2 Deployment Script
# Usage: ./deploy-demo2.sh <instance-ip> <key-file>

if [ $# -ne 2 ]; then
    echo "Usage: $0 <instance-ip> <key-file>"
    echo "Example: $0 1.2.3.4 my-key.pem"
    exit 1
fi

INSTANCE_IP=$1
KEY_FILE=$2

echo "🚀 Deploying easyTravel Demo 2 to $INSTANCE_IP..."

# Connect and deploy
ssh -i "$KEY_FILE" -o StrictHostKeyChecking=no ec2-user@"$INSTANCE_IP" << 'EOF'
# Wait for user-data script to complete
echo "⏳ Waiting for system setup to complete..."
while ! docker --version >/dev/null 2>&1; do
    echo "Waiting for Docker installation..."
    sleep 10
done

while ! docker-compose --version >/dev/null 2>&1; do
    echo "Waiting for Docker Compose installation..."
    sleep 10
done

echo "✅ Docker and Docker Compose are ready!"

# Clone easyTravel repository
echo "📦 Cloning easyTravel repository..."
git clone https://github.com/Dynatrace/easyTravel-Docker.git
cd easyTravel-Docker

# Deploy easyTravel
echo "🚀 Starting easyTravel containers..."
docker-compose up -d

# Setup autostart service
echo "🔄 Setting up autostart service..."
sudo tee /etc/systemd/system/easytravel-autostart.service > /dev/null <<AUTOSTART
[Unit]
Description=easyTravel Docker Compose Application
Requires=docker.service
After=docker.service

[Service]
Type=oneshot
RemainAfterExit=yes
WorkingDirectory=/home/ec2-user/easyTravel-Docker
ExecStart=/usr/local/bin/docker-compose up -d
ExecStop=/usr/local/bin/docker-compose down
TimeoutStartSec=0
User=ec2-user
Group=docker

[Install]
WantedBy=multi-user.target
AUTOSTART

sudo systemctl daemon-reload
sudo systemctl enable easytravel-autostart.service
sudo systemctl start easytravel-autostart.service

echo "✅ easyTravel Demo 2 deployment complete!"
echo "🌐 Access URLs:"
echo "   Main Portal: http://$INSTANCE_IP:80"
echo "   Angular UI: http://$INSTANCE_IP:9079"
echo "   Backend API: http://$INSTANCE_IP:8080"

# Check container status
echo "📊 Container Status:"
docker-compose ps
EOF

echo "✅ Demo 2 deployment script completed!"
