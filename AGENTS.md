# easyTravel Deployment Agent Context

You are an agent that helps deploy and troubleshoot easyTravel demo application on AWS EC2.

Repository URL: https://github.com/Dynatrace/easyTravel-Docker

## Deployment Information
- easyTravel is a Docker-based demo application developed by Dynatrace
- Supports deployment on AWS EC2 instances
- Official documentation: https://community.dynatrace.com/community/display/DL/Demo+Applications+-+easyTravel
- Repository: https://github.com/Dynatrace/easyTravel-Docker

## EC2 Instance Requirements
- **Minimum**: t3.medium (2 vCPU, 4GB RAM)
- **Recommended**: t3.large for better performance
- **Storage**: 20GB minimum (30GB recommended)
- **OS**: Amazon Linux 2 or Ubuntu 20.04/22.04
- **Ports**: 22, 80, 8080, 8091, 9079

## Deployment Strategy
- Local system is CONTROL CENTER only - deploy easyTravel on remote EC2 instance
- Use SSH access with PEM key for remote deployment
- Security group must allow required ports for application access
- Docker and Docker Compose required on target instance
- **CRITICAL**: Install Dynatrace OneAgent BEFORE deploying easyTravel containers

## Installation Process (UPDATED ORDER - OneAgent FIRST)
1. **EC2 Setup**: Launch instance with proper security group
2. **Docker Installation**: Install Docker and Docker Compose
3. **Git Installation**: Install git (required for Amazon Linux 2)
4. **Dynatrace OneAgent**: **INSTALL FIRST** - Use credentials from secrets.yaml
5. **Repository Clone**: Clone easyTravel-Docker repository
6. **Container Deployment**: Run docker-compose up -d
7. **Autostart Setup**: Configure systemd service for automatic restart
8. **Verification**: Check container status and port accessibility

## Autostart Configuration
- **Service File**: `/etc/systemd/system/easytravel-autostart.service`
- **Auto-restart**: easyTravel starts automatically after EC2 reboot
- **Dependencies**: Waits for Docker service to be ready
- **Management**: Use `sudo systemctl start/stop/restart easytravel-autostart.service`

## Dynatrace OneAgent Installation
- **Credentials**: Stored in secrets.yaml (environment URL and API token)
- **Installation Order**: MUST be installed BEFORE easyTravel containers
- **Process**:
  1. Download installer: `wget -O Dynatrace-OneAgent-Linux-x86-*.sh "{url}/api/v1/deployment/installer/agent/unix/default/latest?arch=x86" --header="Authorization: Api-Token {token}"`
  2. Make executable: `chmod +x Dynatrace-OneAgent-Linux-x86-*.sh`
  3. Install: `sudo ./Dynatrace-OneAgent-Linux-x86-*.sh`
  4. Verify: `sudo systemctl status oneagent`
- **Auto-discovery**: OneAgent automatically discovers and monitors Docker containers after installation

## Security Group Configuration
- Port 22: SSH access (restrict to your IP)
- Port 80: Main frontend (0.0.0.0/0 or restricted)
- Port 8080: Backend API (0.0.0.0/0 or restricted)
- Port 8091: Direct backend access (0.0.0.0/0 or restricted)
- Port 9079: Angular frontend (0.0.0.0/0 or restricted)

## Application Architecture
- **NGINX**: Reverse proxy handling external traffic
- **Frontend**: Java-based customer interface
- **Angular Frontend**: Modern customer interface
- **Backend**: Java business logic layer
- **MongoDB**: Pre-populated travel database
- **Load Generators**: Built-in synthetic traffic

## Monitoring Integration
- Compatible with Dynatrace OneAgent
- Built-in problem patterns for demonstration
- Configurable load generation
- Real-time performance monitoring capabilities

## Common Issues & Solutions
- **Git missing**: Amazon Linux 2 requires `sudo yum install git -y` before cloning repository
- **Port conflicts**: Ensure no other services use required ports
- **Memory issues**: Use t3.medium minimum for stable operation
- **Docker permissions**: Add user to docker group and re-login
- **Container startup**: Allow time for all services to initialize
- **Network access**: Verify security group rules for external access

## Useful Commands
```bash
# Check container status
docker-compose ps

# View logs
docker-compose logs -f [service_name]

# Restart services
docker-compose restart

# Stop all services
docker-compose down

# Update and restart
docker-compose pull && docker-compose up -d
```

## Rules
- Always update AGENTS.md when discovering new deployment insights
- Keep infrastructure details in PROGRESS.md
- Use AWS CLI to verify resources before creating new ones
- Document any deployment issues and their solutions
- Test application accessibility after deployment
- **Default Infrastructure Behavior**: Create new EC2 instances by default when requested, maintain consistent naming conventions (e.g., "easyTravel-Demo")
- **Default Region**: Use us-east-2 unless otherwise specified

## Cleanup Strategy

### Complete Infrastructure Cleanup
When cleaning up easyTravel deployments, follow this order to avoid dependency issues:

1. **Terminate EC2 Instances**
   ```bash
   # List instances first
   aws ec2 describe-instances --region us-east-2 --filters "Name=tag:Name,Values=easyTravel*" --query "Reservations[].Instances[].[InstanceId,Tags[?Key=='Name'].Value|[0],State.Name]" --output table
   
   # Terminate instances
   aws ec2 terminate-instances --region us-east-2 --instance-ids INSTANCE_ID
   ```

2. **Delete Key Pairs**
   ```bash
   # List key pairs
   aws ec2 describe-key-pairs --region us-east-2 --query "KeyPairs[].[KeyName,KeyPairId]" --output table
   
   # Delete key pair
   aws ec2 delete-key-pair --region us-east-2 --key-name easytravel-key
   ```

3. **Remove Local PEM Files**
   ```bash
   # Remove from current directory (avoid confusion with old keys)
   rm -f /home/ubuntu/mcpprojects/easytravel-demo/easytravel-key.pem
   rm -f /home/ubuntu/mcpprojects/easytravel-demo/*.pem
   ```

4. **Delete Security Groups** (if custom ones were created)
   ```bash
   # List security groups
   aws ec2 describe-security-groups --region us-east-2 --filters "Name=group-name,Values=easyTravel*" --query "SecurityGroups[].[GroupName,GroupId]" --output table
   
   # Delete security group (only if not default)
   aws ec2 delete-security-group --region us-east-2 --group-id sg-xxxxxxxxx
   ```

5. **Clean Local Files**
   ```bash
   # Remove only PEM files (keep working scripts and service files)
   rm -f /home/ubuntu/mcpprojects/easytravel-demo/*.pem
   ```

### Cleanup Verification
- Verify no running instances: `aws ec2 describe-instances --region us-east-2 --filters "Name=instance-state-name,Values=running"`
- Verify no easyTravel key pairs: `aws ec2 describe-key-pairs --region us-east-2`
- Verify local directory is clean of PEM files: `ls -la *.pem 2>/dev/null || echo "Clean"`

### Important Notes
- **Always terminate instances first** to avoid charges
- **Remove PEM files immediately** after deleting key pairs to prevent confusion
- **Check for custom security groups** - don't delete default VPC security groups
- **Update documentation** after cleanup to reflect current state
- **Verify cleanup completion** before considering task complete

## Critical Mistakes to Avoid
- **Don't assume existing infrastructure**: Always check AWS resources first
- **Don't use hardcoded resource IDs**: Security groups, subnets vary by account/region
- **Don't skip Docker group membership**: User must be in docker group to run containers
- **Don't forget logout/login**: Required after adding user to docker group
- **Don't ignore container logs**: Check logs if services fail to start properly
- **Always verify ports**: Use netstat to confirm services are listening on expected ports
