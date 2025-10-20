# FusionPBX Docker

[![Docker Hub](https://img.shields.io/badge/Docker%20Hub-michaelfangtw%2Ffusionpbx--docker--dev-blue?logo=docker)](https://hub.docker.com/repository/docker/michaelfangtw/fusionpbx-docker-dev)
[![License](https://img.shields.io/badge/License-Same%20as%20FusionPBX-green)](https://github.com/fusionpbx/fusionpbx)

[![Docker Hub](https://img.shields.io/docker/pulls/michaelfangtw/fusionpbx-docker-dev?logo=docker&label=michaelfangtw/fusionpbx-docker-dev)](https://hub.docker.com/r/michaelfangtw/fusionpbx-docker-dev) [![License](https://img.shields.io/badge/License-Same%20as%20FusionPBX-green)](https://github.com/fusionpbx/fusionpbx)

A comprehensive Docker solution for FusionPBX, providing a complete VoIP platform with all necessary components pre-configured and ready to deploy.

**Stack**: Ubuntu 20.04 • FusionPBX 5.2 • FreeSWITCH 1.10.9 • PHP 7.4 • PostgreSQL 12

## 📚 References

- **FusionPBX Install Scripts**: [github.com/fusionpbx/fusionpbx-install.sh](https://github.com/fusionpbx/fusionpbx-install.sh)
- **Docker Hub Repository**: [hub.docker.com/repository/docker/michaelfangtw/fusionpbx-docker-dev](https://hub.docker.com/repository/docker/michaelfangtw/fusionpbx-docker-dev)
## 📋 Table of Contents

- [🏗️ Software Stack](#️-software-stack)
- [📦 Included Services](#-included-services)
- [🚀 Quick Start](#-quick-start)
- [📁 Project Structure](#-project-structure)
- [🔐 Default Credentials](#-default-credentials)
- [🌐 Network Configuration](#-network-configuration)
- [💾 Data Persistence](#-data-persistence)
- [⚙️ Requirements](#️-requirements)
- [🔧 Troubleshooting](#-troubleshooting)
- [📚 Additional Resources](#-additional-resources)
- [🤝 Contributing](#-contributing)
- [📄 License](#-license)

## 🏗️ Software Stack

| Component | Version |
|-----------|---------|
| **Base OS** | Ubuntu 20.04 |
| **FusionPBX** | 5.2 |
| **FreeSWITCH** | 1.10.9 |
| **PHP** | 7.4 |
| **PostgreSQL** | 12 |

## � Included Services

The Docker image includes the following pre-configured services:

- **iptables** - Firewall management
- **sngrep** - SIP packet capture tool
- **fusionpbx** - Web-based PBX system
- **php** - PHP runtime
- **nginx** - Web server
- **postgres** - Database server
- **freeswitch** - Voice over IP platform
- **fail2ban** - Intrusion prevention system

## 🚀 Quick Start

### Step 1: Configure Permissions

Set the proper ownership for the config directory:

```bash
sudo chown 33:33 config -R
```

> **💡 Note**: The `src` directory contains the complete FusionPBX installer source code, allowing for customization and transparency in the build process.

### Step 2: Choose Your Deployment Method

#### Option A: Use Pre-built Image (Recommended)

Pull the latest image from Docker Hub:

```bash
docker pull michaelfangtw/fusionpbx-docker-dev:5.2
```

#### Option B: Build Locally

If you want to build the image locally:
with your password

```bash
#change your password
copy .env.sample .env
docker build -t fusionpbx-docker-dev:5.2 .
```

### Step 3: Configure Docker Compose

The `docker-compose.yaml` file is already configured. Choose your preferred method:

- **1. Pre-built image** (default): Uses `michaelfangtw/fusionpbx-docker-dev:5.2`
- **1. Local build**: Uncomment the `build` section in the compose file

```yaml
services:
  pbx:
    # 1. Use pre-built image from Docker Hub
    image: michaelfangtw/fusionpbx-docker-dev:5.2
    
    # 2. Or build locally (uncomment to use)
    # build:
    #   context: .
    # 3. Or build locally (uncomment to use)
    # image: fusionpbx-docker-dev:5.2
    
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

### Step 4: Start the Container

```bash
docker compose up -d
```

### Step 5: Access the Web Interface

Once the container is running, access FusionPBX at:

- **URL**: [http://localhost](http://localhost)
- **Username**: `admin@localhost`
- **Password**: `YOUR_PASSWORD`  *(set in .env or config.sh)*

## 📁 Project Structure

```
fusionpbx-docker-dev/
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
└── README.md               # Documentation
```

> **📝 Note**: The `src/fusionpbx-install.sh` directory contains the complete official installer with platform-specific scripts and resources for various operating systems.

## 🔐 Default Credentials

### 🌐 Web Interface

- **URL**: [http://localhost](http://localhost)
- **Username**: `admin@localhost`
- **Password**: `YOUR_PASSWORD`  *(set in .env or config.sh)*

### 🗄️ Database (PostgreSQL)

> ⚠️ **IMPORTANT**: Do not change these credentials - they are required for proper operation

- **Host**: `localhost`
- **User**: `fusionpbx`
- **Password**: `YOUR_PASSWORD`  *(set in .env or config.sh)*

## 🌐 Network Configuration

This container uses **host networking mode** to properly handle RTP traffic for VoIP communications. This means:
- All services are accessible on the host's network interface
- No port mapping is required
- FreeSWITCH can properly handle media streams

## 💾 Data Persistence

Configuration data is persisted through Docker volumes:

| Host Path | Container Path | Description |
|-----------|----------------|-------------|
| `./config/fusionpbx` | `/etc/fusionpbx` | FusionPBX configuration files |

## ⚙️ Requirements

- **Docker Engine**: 20.10+
- **Docker Compose**: v2.0+
- **Operating System**: Linux (required for host networking mode)

## 🔧 Troubleshooting

### 🌐 Web Interface Issues

#### Problem: Cannot Access Web Interface

If you can't access the web interface at [http://localhost](http://localhost):

1. **Check container status:**
   ```bash
   docker ps
   ```

2. **View container logs:**
   ```bash
   docker logs fusionpbx
   ```

3. **Check port availability:**
   ```bash
   sudo netstat -tulpn | grep :80
   ```

#### Problem: Login Issues

If you cannot log in to the web interface:

1. **Access the container:**
   ```bash
   docker exec -it fusionpbx /bin/bash
   ```

2. **Backup existing configuration:**
   ```bash
   mv /etc/fusionpbx/config.conf /etc/fusionpbx/config.conf.old
   ```

3. **Reset admin credentials:**
   ```bash
   http://localhost
   1.reset admin
     id=admin 
     pass=YOUR_PASSWORD  *(set in .env or config.sh)*
     domain:localhost

     postgresq
     db host:localhost
     port:5432
     id=fusionpbx
     pass=YOUR_PASSWORD  *(set in .env or config.sh)*

   ```

4. **Use default credentials:**
   - **Username**: `admin`
   - **Password**: `YOUR_PASSWORD`

### 🗄️ Database Issues

#### Problem: Database Connection Failures

If you encounter database-related login failures:

1. **Access the container:**
   ```bash
   docker exec -it fusionpbx /bin/bash
   ```

2. **Navigate to resources directory:**
   ```bash
   cd /src/fusionpbx-install.sh/ubuntu/resources
   ```

3. **Recreate the database:**
   ```bash
   ./postgresql.sh    # Create database
   ./finish.sh        # Set admin credentials
   ```

### 🐳 Container Management

#### Save Changes to Local Image

To preserve modifications made inside the container:

```bash
# Make changes inside the container
docker exec -it fusionpbx /bin/bash
# ... perform your modifications ...
# Exit the container

# Commit changes to create a new image
TAG=5.2
docker commit fusionpbx michaelfangtw/fusionpbx-docker-dev:$TAG
docker push michaelfangtw/fujsionpbx-docker-dev:$TAG
```

#### View Container Logs

```bash
# Real-time logs
docker logs -f fusionpbx

# Last 100 lines
docker logs --tail 100 fusionpbx
```

#### Restart Container

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
