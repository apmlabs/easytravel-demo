#!/bin/bash

# easyTravel Demo 3 Deployment Script
# Instance: i-0f21b99890d536367
# IP: 18.117.175.31
# Key: easytravel-demo3-key.pem

echo "🚀 Deploying easyTravel Demo 3..."

# Connect and deploy
ssh -i easytravel-demo3-key.pem -o StrictHostKeyChecking=no ec2-user@18.117.175.31 << 'EOF'
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

echo "✅ easyTravel Demo 3 deployment complete!"
echo "🌐 Access URLs:"
echo "   Main Portal: http://18.117.175.31:80"
echo "   Angular UI: http://18.117.175.31:9079"
echo "   Backend API: http://18.117.175.31:8080"

# Check container status
echo "📊 Container Status:"
docker-compose ps
EOF

echo "✅ Demo 3 deployment script completed!"
