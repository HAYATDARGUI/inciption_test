*This project has been created as part of the 42 curriculum by hdargui.*

---

## 📝 Description

**Inception** is a System Administration and System Infrastructure project within the 42 Network curriculum. The core objective is to design, build, and orchestrate a multi-service containerized infrastructure using **Docker Compose** running on top of a Debian Linux environment. 

Every service in this architecture runs within its own completely isolated container, ensuring single-responsibility boundaries, security isolation, and strict data persistence. The infrastructure features a highly secure public-facing web platform linked to an automated background ecosystem.

### Project Composition & Sources
The infrastructure consists of the following microservices, with source files organized under `srcs/requirements/`:
*   **NGINX** (`nginx:inception`): The TLS/HTTPS reverse proxy gateway acting as the sole entry point for public traffic.
*   **WordPress** (`wordpress:inception`): Running `php-fpm` natively to process application logic without a standalone web server.
*   **MariaDB** (`mariadb:inception`): The robust relational database engine fueling WordPress.
*   **Redis** (`inception_redis:latest`): In-memory cache layer optimization for database queries.
*   **FTP Server** (`inception_ftp:latest`): A highly secure `vsftpd` container running fully automated user enrollment loops for direct remote volume management.
*   **Adminer** (`inception_adminer:latest`): A minimalist database administration console.
*   **Portainer** (`inception_portainer:latest`): A graphical web panel for real-time monitoring and container orchestration.
*   **Static Website** (`inception_website:latest`): A responsive HTML5 portfolio showcasing the developer's credentials.

---

## 📐 Design Choices & Architectural Comparisons

### 1. Virtual Machines vs Docker Containers
*   **Virtual Machines (VMs):** Abstract a complete machine, including hardware layers and a full Guest Operating System (OS). They require pre-allocated RAM and CPU, creating heavy system footprints, high hypervisor overhead, and slow boot times.
*   **Docker Containers:** Virtualize at the OS kernel level, sharing the Host OS kernel. They are exceptionally lightweight, spin up in seconds, consume memory dynamically, and avoid the performance degradation of guest hypervisors.
*   **Inception Choice:** Docker containers were selected to adhere strictly to the microservices philosophy, allowing application environments to stay minimal, portable, and perfectly reproducible.

### 2. Secrets vs Environment Variables
*   **Environment Variables (`.env`):** Stored in plain text within the system environment or configuration files. They are ideal for non-sensitive settings (e.g., domain names, user handles) but are easily exposed via process inspection (`docker inspect`).
*   **Docker Secrets:** Injected securely directly into runtime memory storage paths (at `/run/secrets/`), avoiding clear-text persistent states on disk, image layers, or in system logs.
*   **Inception Choice:** Critical passwords (MariaDB root/user strings, FTP authentication keys) are managed exclusively through secure Docker Secrets configurations, while standard non-sensitive settings remain in the `.env` pipeline.

### 3. Docker Network vs Host Network
*   **Host Network:** Disables the container’s network isolation, binding services directly to the host machine’s network interfaces. This exposes internal service ports (e.g., database listening channels) to the outer world.
*   **Docker Network (Bridge Mode):** Spins up an isolated software-defined internal network. Containers can resolve each other by container name via embedded DNS queries without revealing ports externally.
*   **Inception Choice:** A strict, custom internal Bridge network (`inception_network`) ensures that only NGINX, Portainer, and the static website expose specific external listening paths, locking all database and backend ports safely inside.

### 4. Docker Volumes vs Bind Mounts
*   **Bind Mounts:** Point straight to arbitrary file paths on the host filesystem. They depend directly on the host's directory layout and file permissions, introducing security flaws and portability challenges.
*   **Docker Volumes:** Managed natively by Docker within internal storage zones. They isolate data workflows from host constraints, guarantee data persistence across image build cycles, and optimize storage performance.
*   **Inception Choice:** High-integrity persistence areas (`wp_data` and `db_data`) are stored strictly using Docker Volumes to enforce container isolation, data consistency, and proper permission boundaries.

---

## 🚀 Instructions

### Prerequisites
*   Operating System: **Debian Bullseye/Bookworm** (or a compatible Linux distribution).
*   Installed Packages: `docker`, `docker-compose-plugin`, `make`.
*   Local DNS setup: Append this line to your host's `/etc/hosts` file:
```text
    127.0.0.1 hdargui.42.fr
    ```

### Compilation & Execution
Run all infrastructure commands from the root directory containing the `Makefile`:

```bash
# 1. Build and boot the entire infrastructure architecture cleanly
make

# 2. Check the real-time health status of running containers
docker ps

# 3. Shutdown and clean up all operational container states
make down

# 4. Total Reset (Wipe out all stored database and volume configurations)
make clean