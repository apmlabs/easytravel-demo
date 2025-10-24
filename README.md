# 🌍 easyTravel on AWS: Your Global Travel Adventure Platform

Welcome to the world's most sophisticated travel booking demo! Deploy a complete travel ecosystem and watch distributed monitoring magic unfold across multiple services. ✈️

> **🎯 Current Status**: Check [amazonq.md](./amazonq.md) for live deployment info!

## 🎭 Meet easyTravel: The Travel Industry Simulator

Picture a bustling travel agency with multiple departments working in perfect harmony. That's easyTravel! This isn't just another demo app - it's a **complete travel ecosystem** that showcases:

- 🏗️ **Multi-tier architecture** with Java frontend, backend, and MongoDB
- 🔄 **Real-world travel workflows** - search, book, pay, manage
- 💥 **Built-in chaos engineering** - multiple problem patterns to break things beautifully
- 🌐 **Modern web interfaces** - both classic Java and Angular frontends
- 🤖 **Synthetic load generation** - realistic user behavior simulation

## 🎒 What You'll Need for This Journey

- 🔑 AWS account with EC2 superpowers
- 🧠 Basic knowledge of AWS EC2 and security groups
- 🐳 Understanding of Docker and multi-service architectures

## 💪 EC2 Power Requirements

Your travel empire needs solid infrastructure! Here's what works:

- **🏆 Proven Champion**: t3.medium (2 vCPU, 4GB RAM) - handles the travel load like a pro!
- **⚡ Upgrade for heavy traffic**: t3.large for extra muscle during peak booking seasons
- **🖥️ Operating System**: Amazon Linux 2 or Ubuntu (your choice!)
- **💾 Storage**: 20GB minimum (30GB for comfort zone)

> **💡 Pro Tip**: t3.medium is surprisingly capable for this travel platform - perfect for demos and testing!

## 🔐 Security Group: Your Digital Airport Security

Create or modify your security group to allow inbound traffic on these ports:

| Port | Protocol | Source | Description | Status |
|------|----------|---------|-------------|---------|
| 22   | TCP      | Your IP | SSH access | 🔑 Essential |
| 80   | TCP      | 0.0.0.0/0 | Main travel portal | 🌐 Public |
| 8080 | TCP      | 0.0.0.0/0 | Backend API | 🔧 API |
| 8091 | TCP      | 0.0.0.0/0 | Direct backend access | 🎯 Direct |
| 9079 | TCP      | 0.0.0.0/0 | Modern Angular frontend | ✨ Modern |

## 🚀 Let's Get This Travel Agency Running!

### 1. 🏗️ Launch Your EC2 Travel Hub
- Choose Amazon Linux 2 AMI (it's reliable for travel!)
- Select t3.medium or larger (trust the travel experts)
- Configure security group as above
- Launch with your key pair

### 2. 🔌 Connect to Your Travel Command Center
```bash
ssh -i your-key.pem ec2-user@YOUR_EC2_PUBLIC_IP
```

### 3. 🐳 Install Docker (The Container Magic)
```bash
sudo yum update -y
sudo yum install docker -y
sudo service docker start
sudo usermod -a -G docker ec2-user
```

### 4. 🔧 Install Docker Compose (The Service Orchestrator)
```bash
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
```

### 5. 📦 Install Git (Amazon Linux 2 only)
```bash
sudo yum install git -y
```

### 6. 👁️ Install Dynatrace OneAgent (The All-Seeing Travel Monitor)

**🚨 Critical**: Install OneAgent BEFORE deploying containers for full monitoring coverage!

```bash
# Download OneAgent installer (replace with your credentials)
wget -O Dynatrace-OneAgent-Linux-x86.sh "https://YOUR_ENVIRONMENT_URL/api/v1/deployment/installer/agent/unix/default/latest?arch=x86" --header="Authorization: Api-Token YOUR_API_TOKEN"

# Make executable and install
chmod +x Dynatrace-OneAgent-Linux-x86.sh
sudo ./Dynatrace-OneAgent-Linux-x86.sh

# Verify installation
sudo systemctl status oneagent
```

### 7. 🔄 Logout and Login Again (Trust the Process)
```bash
exit
ssh -i your-key.pem ec2-user@YOUR_EC2_PUBLIC_IP
```

### 8. 🎯 Deploy easyTravel (The Main Event!)
```bash
git clone https://github.com/Dynatrace/easyTravel-Docker.git
cd easyTravel-Docker
docker-compose up -d
```

### 9. 🔄 Setup Autostart (Because Travel Never Stops)

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

### 10. ✅ Verify Your Travel Empire is Live
```bash
docker-compose ps
```

All services should show "Up" status. Your travel platform is ready for business! 🎉

## 🎉 Access Your Travel Empire

Once deployed, explore your travel platform using your EC2 public IP:

- **🌟 Main Travel Portal**: `http://YOUR_EC2_PUBLIC_IP:80`
- **✨ Modern Angular Interface**: `http://YOUR_EC2_PUBLIC_IP:9079`
- **🔧 Backend API**: `http://YOUR_EC2_PUBLIC_IP:8080`

## 🏗️ Your Travel Architecture (Behind the Scenes)

| Component | Description | Port | Role |
|-----------|-------------|------|------|
| NGINX | Traffic director | 80, 8080, 9079 | 🚦 Router |
| Frontend | Classic travel interface (Java) | Internal | 🏛️ Classic |
| Angular Frontend | Modern travel interface | Internal | ✨ Modern |
| Backend | Business logic powerhouse | 8091 | 🧠 Brain |
| MongoDB | Travel database with destinations | 27017 | 🗄️ Memory |
| Load Generators | Synthetic travelers | Internal | 🤖 Robots |

## 💥 Built-in Travel Chaos (Problem Patterns)

Your travel platform includes realistic problem scenarios for demonstration:

- 🐌 **BadCacheSynchronization**: Slow booking responses
- 🔥 **CPULoad**: High server load during peak season
- 🧹 **DatabaseCleanup**: Database maintenance issues
- 🔍 **JourneySearchError404/500**: Search functionality problems
- 🔐 **LoginProblems**: Authentication difficulties
- 📱 **MobileErrors**: Mobile app issues
- 🧠 **Memory leaks**: Gradual performance degradation
- And many more travel nightmares! 😈

## 🛠️ Travel Management Commands

### Check your travel services
```bash
docker-compose logs -f [service_name]
```

### Pause travel operations
```bash
docker-compose down
```

### Restart travel services
```bash
docker-compose restart
```

### Update your travel platform
```bash
docker-compose pull
docker-compose up -d
```

## 🔧 Troubleshooting Your Travel Platform

### Check if travelers can reach you
```bash
sudo netstat -tlnp | grep -E ':(80|8080|8091|9079)'
```

### Inspect your travel services
```bash
docker ps -a
```

### Read service logs
```bash
docker logs [container_name]
```

### Clean up travel debris
```bash
docker system prune -a
```

## 💰 Cost Optimization for Your Travel Business

- Use **t3.medium** for demos (handles moderate traveler load)
- **Stop instance** when the travel agency is closed to save costs
- Consider **Spot instances** for temporary travel promotions
- Use **Elastic IP** if you need a permanent travel address

## 🔒 Travel Security Notes

- Restrict security group sources to your IP when possible
- Consider using **Application Load Balancer** for production travel sites
- Monitor CloudWatch for traveler traffic patterns
- Set up **CloudWatch alarms** for cost control during peak seasons

## 🎯 Next Steps for Your Travel Empire

1. Install Dynatrace OneAgent on the EC2 instance for full visibility
2. Configure monitoring in your Dynatrace tenant
3. Explore the built-in problem patterns (break things safely!)
4. Generate synthetic traveler load and observe the magic
5. Set up business event capture for booking analytics

## 🧹 Cleanup Your Travel Infrastructure

### Option 1: Close Travel Agency Temporarily (Preserve for Later)

For temporary shutdown while keeping all your travel configuration:

```bash
# Close the travel agency (preserves everything)
aws ec2 stop-instances --region us-east-2 --instance-ids YOUR_INSTANCE_ID

# Reopen for business later
aws ec2 start-instances --region us-east-2 --instance-ids YOUR_INSTANCE_ID
```

**Benefits**: No redeployment needed, faster reopening, keeps all travel bookings and configuration.
**Note**: Your travel agency address (public IP) changes after reopening.

### Option 2: Permanent Travel Agency Closure

When you're done with the travel demo permanently:

1. **Close travel operations**: `aws ec2 terminate-instances --region us-east-2 --instance-ids YOUR_INSTANCE_ID`
2. **Destroy travel credentials**: `aws ec2 delete-key-pair --region us-east-2 --key-name easytravel-key`
3. **Remove local travel keys**: `rm -f easytravel-key.pem`
4. **Clean up travel security** (if custom security groups were created)

Always terminate instances first to stop travel expenses immediately! 💸

---

**🌍 Repository**: https://github.com/Dynatrace/easyTravel-Docker  
**📚 Documentation**: https://community.dynatrace.com/community/display/DL/Demo+Applications+-+easyTravel  
**🎯 Architecture**: Multi-tier travel platform with distributed monitoring  
**✈️ Use Case**: Complete travel booking application for Dynatrace demonstrations  
**📊 Context**: See [amazonq.md](./amazonq.md) for current deployment status
