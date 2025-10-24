# Amazon Q Context - easyTravel Demo Status

## Current Deployment Status: ACTIVE ✅

**Last Updated**: October 24, 2025 22:40 UTC

## Active Infrastructure
- **EC2 Instance**: i-0c5ef124888fe4384 (t3.medium, us-east-2)
- **Public IP**: 18.222.237.255
- **Key Pair**: easytravel-key
- **Security Group**: sg-c868b9a7 (ports 22, 80, 8080, 8091, 9079)

## Application Status
✅ **easyTravel Demo FULLY DEPLOYED and RUNNING**
- All 8 containers operational
- Dynatrace OneAgent installed and monitoring
- Autostart service configured for persistence
- All application URLs accessible

## Quick Access URLs
- **Main Frontend**: http://18.222.237.255:80
- **Angular Frontend**: http://18.222.237.255:9079
- **Backend API**: http://18.222.237.255:8080

## Key Context for Conversations
- **DO NOT create new infrastructure** - demo is already running
- **Current deployment is production-ready** with monitoring and autostart
- **Instance will auto-restart** easyTravel after reboot
- **OneAgent properly installed** before containers for full monitoring

## Available Actions
- Check application status
- Access demo URLs
- Troubleshoot if needed
- Clean up when demo complete
- Scale or modify existing deployment

## Infrastructure Details
- **Region**: us-east-2
- **AMI**: ami-015627ae848dee040 (Amazon Linux 2)
- **Deployment Date**: October 24, 2025
- **Monitoring**: Dynatrace OneAgent active
- **Persistence**: systemd autostart service enabled
