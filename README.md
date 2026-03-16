# Local DevOps Lab Environment
https://mighty-numbers-smash.loca.lt/
A complete local DevOps lab environment demonstrating Infrastructure as Code (IaC), Configuration Management, Containerization, and System Monitoring. This project creates a professional monitoring dashboard using Flask, deployed with Docker and orchestrated with Ansible - all running locally without any cloud providers.

## 🏗️ Architecture Overview

```
┌─────────────────────────────────────────────────────────────┐
│                    Local DevOps Lab                        │
├─────────────────────────────────────────────────────────────┤
│  Host Machine (Windows/Linux/macOS)                        │
│  ├── VirtualBox                                            │
│  ├── Vagrant                                               │
│  └── Project Files                                         │
└─────────────────────────────────────────────────────────────┘
           │
           ▼
┌─────────────────────────────────────────────────────────────┐
│                Virtual Machines                            │
├─────────────────────────────────────────────────────────────┤
│  ┌─────────────────┐    ┌─────────────────────────────────┐ │
│  │  mgmt-server    │    │         web-server              │ │
│  │  192.168.56.11  │    │         192.168.56.10           │ │
│  │                 │    │                                 │ │
│  │ • Ansible       │    │ • Docker & Docker Compose       │ │
│  │ • SSH Control   │    │ • Flask Monitoring App          │ │
│  │ • Git           │    │ • Nginx Reverse Proxy           │ │
│  └─────────────────┘    │ • System Dashboard (Port 80)    │ │
│                          └─────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────┘
```

## 📋 Prerequisites

### Required Software
- **VirtualBox** (latest version)
- **Vagrant** (latest version)
- **Git** (for version control)

### System Requirements
- **RAM**: Minimum 8GB (16GB recommended)
- **Storage**: Minimum 20GB free space
- **CPU**: 4+ cores recommended

## 🚀 Quick Start

### Step 1: Clone and Navigate to Project
```bash
git clone <your-repo-url>
cd devopsproject
```

### Step 2: Start Virtual Machines
```bash
vagrant up
```

This will create and configure two Ubuntu 22.04 VMs:
- **web-server** (192.168.56.10) - 2GB RAM
- **mgmt-server** (192.168.56.11) - 1GB RAM

### Step 3: Deploy Application with Ansible
```bash
# SSH into the management server
vagrant ssh mgmt-server

# Navigate to the shared project directory
cd /vagrant

# Run the Ansible playbook
ansible-playbook -i ansible/inventory.ini ansible/playbook.yml
```

### Step 4: Access the Monitoring Dashboard
Open your web browser and navigate to:
```
http://192.168.56.10
```

## 📊 System Monitoring Dashboard Features

The Flask application provides a real-time system monitoring dashboard with:

- **CPU Usage**: Real-time CPU percentage and core count
- **Memory Usage**: RAM utilization with total/used/available metrics
- **Disk Space**: Storage utilization with detailed breakdown
- **System Information**: Boot time and hardware specifications
- **Auto-refresh**: Dashboard updates every 5 seconds
- **Responsive Design**: Works on desktop and mobile devices

## 📁 Project Structure

```
devopsproject/
├── Vagrantfile                 # Virtual machine configuration
├── docker-compose.yml          # Container orchestration
├── README.md                   # This documentation
├── app/                        # Flask application
│   ├── app.py                  # Main Flask application
│   ├── requirements.txt        # Python dependencies
│   ├── Dockerfile              # Container build instructions
│   └── templates/
│       └── dashboard.html      # Web dashboard template
├── ansible/                    # Configuration management
│   ├── inventory.ini           # Host inventory
│   └── playbook.yml            # Deployment automation
└── nginx/                      # Reverse proxy configuration
    ├── nginx.conf              # Main Nginx configuration
    └── default.conf            # Site-specific configuration
```

## 🔧 Detailed Setup Instructions

### Virtual Machine Configuration

#### Vagrantfile Details
- **Base Box**: ubuntu/jammy64 (Ubuntu 22.04)
- **Networking**: Private network (192.168.56.0/24)
- **Providers**: VirtualBox
- **Provisioning**: Shell script for Ansible setup

#### VM Specifications
- **web-server**: 2GB RAM, 1 CPU, IP: 192.168.56.10
- **mgmt-server**: 1GB RAM, 1 CPU, IP: 192.168.56.11

### Application Deployment

#### Flask Application Features
- Built with **Flask 2.3.3** and **psutil 5.9.5**
- Real-time system metrics collection
- RESTful API endpoint at `/api/system`
- Responsive web interface with modern CSS
- Health checks and error handling

#### Docker Configuration
- **Base Image**: python:3.9-slim (lightweight)
- **Security**: Non-root user execution
- **Health Checks**: Container health monitoring
- **Optimization**: Multi-stage build pattern

#### Nginx Reverse Proxy
- **Version**: nginx:1.24-alpine
- **Features**: 
  - Load balancing and upstream configuration
  - Gzip compression
  - Security headers
  - Health check endpoints
  - Timeout configurations

### Ansible Automation

#### Playbook Tasks
1. **System Preparation**: Update packages, install dependencies
2. **Docker Installation**: Official Docker CE with Compose plugin
3. **Application Deployment**: Code copy, container build, service start
4. **Health Verification**: Service availability checks
5. **User Configuration**: Docker group permissions

#### Inventory Configuration
- **Groups**: web, mgmt
- **Authentication**: SSH key-based with password fallback
- **Python**: Python 3 interpreter specification
- **Security**: Host key checking disabled for lab environment

## 🛠️ Troubleshooting

### Common Issues and Solutions

#### Vagrant Issues
```bash
# If VMs fail to start
vagrant destroy -f
vagrant up

# If networking issues occur
vagrant reload
```

#### Ansible Connection Issues
```bash
# Test SSH connectivity
vagrant ssh web-server
vagrant ssh mgmt-server

# Check Ansible inventory
ansible-inventory -i ansible/inventory.ini --list

# Test Ansible connectivity
ansible all -i ansible/inventory.ini -m ping
```

#### Docker Issues
```bash
# Check container status
docker ps -a

# View container logs
docker logs monitoring-flask-app
docker logs monitoring-nginx

# Restart services
cd /opt/monitoring-app
docker-compose restart
```

#### Application Access Issues
```bash
# Check if application is running locally
curl http://localhost:80

# Check Nginx configuration
docker exec monitoring-nginx nginx -t

# Test Flask app directly
curl http://localhost:5000
```

### Performance Optimization

#### System Resources
- Ensure adequate RAM (8GB+ recommended)
- Monitor VM resource usage with `htop`
- Adjust VM memory in Vagrantfile if needed

#### Network Performance
- Use VirtualBox's NAT + Host-only networking
- Configure port forwarding if required
- Check firewall settings on host system

## 🔒 Security Considerations

### Lab Environment Security
- **SSH Keys**: Password authentication enabled for convenience
- **Docker**: User added to docker group (development convenience)
- **Network**: Private network isolation
- **Firewall**: Basic UFW configuration recommended

### Production Hardening (for reference)
- Implement SSH key-based authentication only
- Use Docker secrets for sensitive data
- Configure firewall rules
- Implement SSL/TLS termination
- Regular security updates

## 📈 Monitoring and Maintenance

### System Health Checks
```bash
# Check VM status
vagrant status

# Monitor Docker containers
docker stats

# Check application logs
docker-compose logs -f
```

### Backup and Recovery
```bash
# Export VM configurations
vagrant package --output web-server.box web-server
vagrant package --output mgmt-server.box mgmt-server

# Backup application data
docker-compose down
cp -r /opt/monitoring-app /backup/
```

## 🧪 Development and Testing

### Local Development
```bash
# Test Flask app locally
cd app
python -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate
pip install -r requirements.txt
python app.py
```

### Container Testing
```bash
# Build and test containers
docker-compose build
docker-compose up -d
docker-compose ps
```

### Ansible Testing
```bash
# Dry run playbook
ansible-playbook -i ansible/inventory.ini ansible/playbook.yml --check

# Test specific tasks
ansible-playbook -i ansible/inventory.ini ansible/playbook.yml --tags docker
```

## 📚 Learning Objectives

This project demonstrates:
- **Infrastructure as Code**: Vagrant for VM provisioning
- **Configuration Management**: Ansible for automation
- **Containerization**: Docker for application packaging
- **Orchestration**: Docker Compose for multi-container services
- **Web Technologies**: Flask, HTML5, CSS3, JavaScript
- **System Administration**: Linux, networking, security
- **DevOps Practices**: CI/CD pipeline readiness, monitoring

## 🤝 Contributing

Feel free to submit issues, feature requests, or pull requests to enhance this DevOps lab environment.

## 📄 License

This project is provided for educational purposes. Feel free to use and modify according to your needs.

---

**🎯 Congratulations!** You now have a fully functional local DevOps lab environment with real-time system monitoring capabilities.
