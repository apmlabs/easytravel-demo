# Amazon Q Context - easyTravel Demo Status

## Current Deployment Status: ACTIVE ✅

**Last Updated**: October 24, 2025 23:37 UTC

## Active Infrastructure
- **EC2 Instance**: i-0c5ef124888fe4384 (t3.medium, us-east-2)
- **Public IP**: 18.118.168.29
- **Key Pair**: easytravel-key
- **Security Group**: sg-c868b9a7 (ports 22, 80, 8080, 8091, 9079)

## Application Status
✅ **easyTravel Demo FULLY DEPLOYED and RUNNING**
- All travel services operational
- Dynatrace OneAgent installed and monitoring
- Autostart service configured for persistence
- Travel platform accessible at multiple endpoints

## Quick Access
- **🌟 Main Travel Portal**: http://18.118.168.29:80
- **✨ Modern Angular Interface**: http://18.118.168.29:9079
- **🔧 Backend API**: http://18.118.168.29:8080

## Key Context for Conversations
- **DO NOT create new infrastructure** - demo is already running
- **Current deployment is production-ready** with monitoring and autostart
- **Instance will auto-restart** all services after reboot
- **OneAgent properly installed** before containers for full monitoring

## Available Actions
- Check application status
- Access demo URLs
- Test problem patterns
- **Shutdown instance** (preserves all config for later restart)
- **Terminate completely** (permanent cleanup)

## Restart Commands
```bash
# Start the stopped instance
aws ec2 start-instances --region us-east-2 --instance-ids i-0c5ef124888fe4384

# Get new public IP after restart
aws ec2 describe-instances --region us-east-2 --instance-ids i-0c5ef124888fe4384 --query "Reservations[].Instances[].[InstanceId,PublicIpAddress,State.Name]" --output table
```

## Infrastructure Details
- **Region**: us-east-2
- **AMI**: ami-015627ae848dee040 (Amazon Linux 2)
- **Deployment Date**: October 24, 2025
- **Monitoring**: Dynatrace OneAgent active
- **Persistence**: systemd autostart service enabled

---

## Status Templates for Different States

### When Instance is STOPPED (use this template):
```
## Current Deployment Status: STOPPED 🛑

**Last Updated**: [TIMESTAMP]

## Stopped Infrastructure
- **EC2 Instance**: [INSTANCE_ID] (t3.medium, us-east-2) - STOPPED
- **Key Pair**: easytravel-key (preserved)
- **Security Group**: [SG_ID] (preserved)

## Application Status
🛑 **easyTravel Demo STOPPED** (all configuration preserved)
- Instance stopped to save costs
- All configuration and data intact
- Ready for quick restart (2-3 minutes)
- Autostart service will restore containers on restart

## Key Context for Conversations
- **DO NOT create new infrastructure** - existing instance just needs restart
- **All configuration preserved** - no redeployment needed
- **Quick restart available** - just start the existing instance
- **Public IP will change** after restart (get new IP from AWS)

## Available Actions
- **Restart existing instance** (fastest option)
- Check instance status
- **Terminate completely** (permanent cleanup)

## Restart Commands
```bash
# Start the stopped instance
aws ec2 start-instances --region us-east-2 --instance-ids [INSTANCE_ID]

# Get new public IP after restart
aws ec2 describe-instances --region us-east-2 --instance-ids [INSTANCE_ID] --query "Reservations[].Instances[].[InstanceId,PublicIpAddress,State.Name]" --output table
```
```

### When Infrastructure is TERMINATED (use this template):
```
## Current Deployment Status: NO DEPLOYMENT 🚫

**Last Updated**: [TIMESTAMP]

## Infrastructure Status
- **No active infrastructure** - all resources terminated
- **Clean slate** - ready for new deployment

## Key Context for Conversations
- **Infrastructure needed** - no existing deployment
- **Fresh deployment required** - follow full setup process
- **No preserved configuration** - start from scratch

## Available Actions
- Deploy new easyTravel infrastructure
- Follow complete setup guide
- Create new EC2 instance with proper configuration
```
