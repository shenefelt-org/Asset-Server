# Server Setup & Asset Provisioning

Base setup scripts and configurations for provisioning system packages, access control lists (ACLs), Samba file sharing, and developer tooling.

---

## Quick Start

Run the following commands on your server to download the setup assets and trigger execution:

```bash
# Ensure read/write/execute permissions to the /srv directory
sudo chmod +rwx /srv

# Pull down assets and automatically extract to /srv
curl -sSL [https://assets.shenefelt.org/setup.tar.gz](https://assets.shenefelt.org/setup.tar.gz) | tar -xz -C /srv

# Navigate to /srv and run setup
cd /srv
./assets/base_setup.sh
```

---

## Setup Components

| Category | Component | Type | Description |
| :--- | :--- | :--- | :--- |
| **Package** | `snapd` | System Utility | Canonical's app deployment and package management system |
| **Package** | `redis` | Database / Cache | High-performance in-memory data store |
| **Package** | `nginx` | Web Server | Reverse proxy and HTTP asset web server |
| **Package** | `ufw` | Security | Uncomplicated Firewall for host protection |
| **Package** | `samba` | File Sharing | SMB/CIFS provider for network folder sharing |
| **Package** | `acl` | Access Control | Utilities for managing permissions (`setfacl`/`getfacl`) |
| **Package** | `btop` | System Monitor | Interactive, graphical TUI resource monitor |
| **Package** | `mariadb-server` | Database | Relational SQL database engine |
| **Script** | `install-1pass-beta.sh` | External Installer | Automated setup for the 1Password CLI |
| **Script** | `setup_neovim_with_lazyvim.sh` | External Installer | Configuration for Neovim with LazyVim |