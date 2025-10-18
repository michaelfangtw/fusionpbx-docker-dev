# FusionPBX Docker
Base OS: Ubuntu 20.04/FusionPBX: 5.1/FreeSWITCH: 1.10.9/PHP: 7.4/PostgreSQL: 12

A Docker implementation of FusionPBX 5.1 based on the official [fusionpbx-install.sh](https://github.com/fusionpbx/fusionpbx-install.sh) installer. This project provides a complete, containerized PBX solution with all necessary components pre-configured and ready to deploy.

## 📋 Table of Contents
- [Software Stack](#-software-stack)
- [Included Services](#-included-services)
- [Quick Start](#-quick-start)
- [Project Structure](#-project-structure)
- [Default Credentials](#-default-credentials)
- [Network Configuration](#-network-configuration)
- [Data Persistence](#-data-persistence)
- [Requirements](#-requirements)
- [Troubleshooting](#-troubleshooting)

## 🏗️ Software Stack

| Component | Version |
|-----------|---------|
| **Base OS** | Ubuntu 20.04 |
| **FusionPBX** | 5.1 |
| **FreeSWITCH** | 1.10.9 |
| **PHP** | 7.4 |
| **PostgreSQL** | 12 |

## 📋 Included Services

The Docker image includes the following services:

- **iptables** - Firewall management
- **sngrep** - SIP packet capture tool
- **fusionpbx** - Web-based PBX system
- **php** - PHP runtime
- **nginx** - Web server
- **postgres** - Database server
- **freeswitch** - Voice over IP platform
- **fail2ban** - Intrusion prevention system

## 🚀 Quick Start

### 1. Configure Permissions

First, set the proper ownership for the config directory:

```bash
chown 33:33 config -R
```

> **Note**: The `src` directory contains the complete FusionPBX installer source code, allowing for customization and transparency in the build process.

### 2. Choose Your Deployment Method

#### Option A: Use Pre-built Image (Recommended)
Pull the latest image from Docker Hub:
```bash
docker pull michaelfangtw/fusionpbx-docker-dev:5.1
```

#### Option B: Build Locally
If you want to build the image locally:
```bash
docker build -t fusionpbx-docker-dev:5.1 .
```

**Docker Hub Repository**: [michaelfangtw/fusionpbx-docker-dev](https://hub.docker.com/repository/docker/michaelfangtw/fusionpbx-docker-dev)

### 3. Configure Docker Compose

The `docker-compose.yaml` file is already configured. You can use either:

- **Pre-built image** (default): `michaelfangtw/fusionpbx-docker-dev:5.1`
- **Local build**: Uncomment the `build` section in the compose file

```yaml
services:
  pbx:
    # Use pre-built image from Docker Hub
    image: michaelfangtw/fusionpbx-docker-dev:5.1
    
    # Or build locally (uncomment to use)
    # build:
    #   context: .

    # Host networking for RTP port range
    network_mode: "host"
    container_name: fusionpbx
    restart: always
    privileged: true

    # Persist configuration
    volumes:
      - ./config/fusionpbx:/etc/fusionpbx

    entrypoint: ["/usr/sbin/init"]
```

### 4. Start the Container

```bash
docker compose up -d
```

## � Project Structure

```
fusionpbx-docker/
├── config/                    # Configuration files
│   └── fusionpbx/            # FusionPBX configuration
├── src/                      # Source code and installers
│   └── fusionpbx-install.sh/ # Official FusionPBX installer scripts
│       ├── centos/           # CentOS installation scripts
│       ├── debian/           # Debian installation scripts
│       ├── devuan/           # Devuan installation scripts
│       ├── freebsd/          # FreeBSD installation scripts
│       ├── ubuntu/           # Ubuntu installation scripts
│       └── windows/          # Windows installation scripts
├── docker-compose.yaml       # Docker Compose configuration
├── Dockerfile               # Docker image definition
└── README.md               # This file
```

The `src/fusionpbx-install.sh` directory contains the complete official installer with platform-specific scripts and resources for various operating systems.

## 🔐 Default Credentials

### Web Interface
- **URL**: http://localhost
- **Username**: admin@localhost
- **Password**: password

### Database (PostgreSQL)
⚠️ **DO NOT CHANGE** - Required for proper operation:
- **Host**: localhost
- **User**: fusionpbx
- **Password**: password

## 🌐 Network Configuration

This container uses **host networking mode** to properly handle RTP traffic for VoIP communications. This means:
- All services are accessible on the host's network interface
- No port mapping is required
- FreeSWITCH can properly handle media streams

## 💾 Data Persistence

The following directory is mounted as a volume to persist configuration:
- `./config/fusionpbx:/etc/fusionpbx` - FusionPBX configuration files

## 🔧 Requirements

- Docker Engine 20.10+
- Docker Compose v2.0+
- Linux host (required for host networking mode)

## 🔧 Troubleshooting

### Common Issues

#### Web Interface Not Accessible
If you can't access the web interface at http://localhost:
1. Check if the container is running: `docker ps`
2. Check container logs: `docker logs fusionpbx`
3. Ensure no other service is using port 80/443

#### Reset Admin Credentials
If you cannot log in to the web interface:

1. **Access the container:**
   ```bash
   docker exec -it fusionpbx /bin/bash
   ```

2. **Backup existing config:**
   ```bash
   mv /etc/fusionpbx/config.conf /etc/fusionpbx/config.conf.old
   ```

3. **Reset admin credentials:**
   ```bash
   cd /src/fusionpbx-install.sh/ubuntu/resources
   ./finish.sh
   ```

4. **Default credentials will be:**
   - **Username**: admin
   - **Password**: password

### Database Connection Issues

If you encounter database-related login failures, re-run the installation steps inside the container:

1. Access the container:
   ```bash
   docker exec -it fusionpbx /bin/bash
   ```

2. Navigate to the resources directory:
   ```bash
   cd /src/fusionpbx-install.sh/ubuntu/resources
   ```

3. Recreate the database:
   ```bash
   ./postgresql.sh    # Create database
   ./finish.sh        # Set admin credentials
   ```

### Container Management

#### Save Changes to Local Image
If you make changes inside the container and want to save them:

```bash
# Make your changes inside the container
docker exec -it fusionpbx /bin/bash
# ... make your modifications ...

# Commit changes to create a new image
docker commit fusionpbx fusionpbx-docker-dev:5.1
```

#### Container Logs
View real-time logs:
```bash
docker logs -f fusionpbx
```

#### Restart Services
Restart the container:
```bash
docker restart fusionpbx
```

## 📚 Additional Resources

- [FusionPBX Official Documentation](https://docs.fusionpbx.com/)
- [FusionPBX Install Scripts](https://github.com/fusionpbx/fusionpbx-install.sh)
- [FreeSWITCH Documentation](https://freeswitch.org/confluence/)
- [Docker Hub Repository](https://hub.docker.com/repository/docker/michaelfangtw/fusionpbx-docker-dev)

## 🤝 Contributing

This project includes the complete FusionPBX installer source code in the `src/` directory for transparency and customization. Feel free to submit issues and pull requests.

## 📄 License

This project follows the same licensing as the original FusionPBX project. Please refer to the official [FusionPBX repository](https://github.com/fusionpbx/fusionpbx) for license details.
