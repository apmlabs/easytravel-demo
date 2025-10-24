# easyTravel-Docker on AWS EC2 Setup Guide

This guide shows how to deploy the Dynatrace easyTravel demo application on an AWS EC2 instance.

## Prerequisites

- AWS account with EC2 access
- Basic knowledge of AWS EC2 and security groups

## EC2 Instance Requirements

- **Instance Type**: t3.medium or larger (minimum 2GB RAM)
- **Operating System**: Amazon Linux 2 or Ubuntu
- **Storage**: 20GB minimum

## Security Group Configuration

Create or modify your security group to allow inbound traffic on these ports:

| Port | Protocol | Source | Description |
|------|----------|---------|-------------|
| 22   | TCP      | Your IP | SSH access |
| 80   | TCP      | 0.0.0.0/0 | Main frontend |
| 8080 | TCP      | 0.0.0.0/0 | Backend API |
| 8091 | TCP      | 0.0.0.0/0 | Direct backend access |
| 9079 | TCP      | 0.0.0.0/0 | Angular frontend |

## Installation Steps

### 1. Launch EC2 Instance
- Choose Amazon Linux 2 AMI
- Select t3.medium or larger
- Configure security group as above
- Launch with your key pair

### 2. Connect to Instance
```bash
ssh -i your-key.pem ec2-user@YOUR_EC2_PUBLIC_IP
```

### 3. Install Docker
```bash
sudo yum update -y
sudo yum install docker -y
sudo service docker start
sudo usermod -a -G docker ec2-user
```

### 4. Install Docker Compose
```bash
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
```

### 5. Install Git (Amazon Linux 2 only)
```bash
sudo yum install git -y
```

### 6. Logout and Login Again
```bash
exit
ssh -i your-key.pem ec2-user@YOUR_EC2_PUBLIC_IP
```

### 7. Deploy easyTravel
```bash
git clone https://github.com/Dynatrace/easyTravel-Docker.git
cd easyTravel-Docker
docker-compose up -d
```

### 8. Setup Autostart (Optional but Recommended)

Configure easyTravel to start automatically after reboot:

```bash
# Create systemd service file
sudo tee /etc/systemd/system/easytravel-autostart.service > /dev/null <<EOF
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
EOF

# Enable and start the service
sudo systemctl daemon-reload
sudo systemctl enable easytravel-autostart.service
sudo systemctl start easytravel-autostart.service
```

### 9. Verify Deployment
```bash
docker-compose ps
```

All services should show "Up" status.

## Access the Application

Once deployed, access the application using your EC2 public IP:

- **Main Frontend**: `http://YOUR_EC2_PUBLIC_IP:80`
- **Angular Frontend**: `http://YOUR_EC2_PUBLIC_IP:9079`
- **Backend API**: `http://YOUR_EC2_PUBLIC_IP:8080`

## Application Components

| Component | Description | Port |
|-----------|-------------|------|
| MongoDB | Pre-populated travel database | 27017 |
| Backend | Business logic (Java) | 8091 |
| Frontend | Customer interface (Java) | Internal |
| Angular Frontend | Modern customer interface | Internal |
| NGINX | Reverse proxy | 80, 8080, 9079 |
| Load Generators | Synthetic traffic generation | Internal |

## Built-in Problem Patterns

The application includes configurable problem patterns for demonstration:

- BadCacheSynchronization
- CPULoad
- DatabaseCleanup
- JourneySearchError404/500
- LoginProblems
- MobileErrors
- Memory leaks
- And more...

## Useful Commands

### View logs
```bash
docker-compose logs -f [service_name]
```

### Stop application
```bash
docker-compose down
```

### Restart application
```bash
docker-compose restart
```

### Update images
```bash
docker-compose pull
docker-compose up -d
```

## Troubleshooting

### Check if ports are accessible
```bash
sudo netstat -tlnp | grep -E ':(80|8080|8091|9079)'
```

### Check container status
```bash
docker ps -a
```

### View container logs
```bash
docker logs [container_name]
```

### Free up disk space
```bash
docker system prune -a
```

## Cost Optimization

- Use **t3.medium** for demos (can handle moderate load)
- **Stop instance** when not in use to save costs
- Consider **Spot instances** for temporary demos
- Use **Elastic IP** if you need consistent access

## Security Notes

- Restrict security group sources to your IP when possible
- Consider using **Application Load Balancer** for production-like setups
- Monitor CloudWatch for resource usage
- Set up **CloudWatch alarms** for cost control

## Next Steps

1. Install Dynatrace OneAgent on the EC2 instance
2. Configure monitoring in your Dynatrace tenant
3. Explore the built-in problem patterns
4. Generate load and observe monitoring data

## Cleanup

When you're done with the demo, clean up resources to avoid charges:

1. **Terminate EC2 instance**: `aws ec2 terminate-instances --region us-east-2 --instance-ids YOUR_INSTANCE_ID`
2. **Delete key pair**: `aws ec2 delete-key-pair --region us-east-2 --key-name easytravel-key`
3. **Remove local PEM file**: `rm -f easytravel-key.pem`
4. **Delete custom security groups** (if any were created)

Always terminate instances first to stop charges immediately.

---

**Repository**: https://github.com/Dynatrace/easyTravel-Docker
**Documentation**: https://community.dynatrace.com/community/display/DL/Demo+Applications+-+easyTravel
