# DEMO 1 - Basic SQL container management
#   1- Get SQL Server image list from MCR (Microsoft Container Registry)
#   2- Create new SQL container
#   3- Basic container management commands
#   4- Cleanup
# -----------------------------------------------------------------------------
# Reference
#   Quistart: SQL Server with Docker
#   https://docs.microsoft.com/en-us/sql/linux/quickstart-install-connect-docker?view=sql-server-ver15&pivots=cs1-bash
#
#   Docker commands aliases
#   https://www.sqlservercentral.com/articles/creating-aliases-for-most-command-docker-commands
#
#   Creating your first SQL Server container in macOS
#   https://www.red-gate.com/simple-talk/sysadmin/containerization/creating-your-first-sql-server-docker-container-in-macos/

# 0- Env variables | demo path
cd ~/Documents/Getting-started-SQLContainers/Demo_01;

# 1- Get SQL Server image list from MCR (Microsoft Container registry)
# Docker Hub images
https://hub.docker.com/_/microsoft-mssql-server

# Using command line
# Ubuntu based images
curl -s -L https://mcr.microsoft.com/v2/mssql/server/tags/list/

### Powershell 👇 🔌🐚
pwsh -c "(Invoke-WebRequest -URI https://mcr.microsoft.com/v2/mssql/server/tags/list/).content"

# RHEL based images
curl -s -L https://mcr.microsoft.com/v2/mssql/rhel/server/tags/list/

### Powershell 👇 🔌🐚
pwsh -c "(Invoke-WebRequest -URI https://mcr.microsoft.com/v2/mssql/rhel/server/tags/list/).content"

# 2- Create new SQL container
docker run \
    --name SQL-Plex \
    --hostname SQL-Plex \
    --env 'ACCEPT_EULA=Y' \
    --env 'MSSQL_SA_PASSWORD=_SqLr0ck5_' \
    --publish 1401:1433 \
    --detach mcr.microsoft.com/mssql/server:2019-CU6-ubuntu-18.04

# 3- Basic container management commands
### Docker aliases 🐳 📝 
### SQL Server Central Article 👇 👍
### https://bit.ly/2wcxEJj

# Get status of all containers
# Alias version - dkpsa
# Active containers
docker ps

# List all containers (no filter)
docker ps -a

# List all containers using formatted table
docker ps -a --format "table {{.Names}}\t{{.Image}}\t{{.Status}}"
docker ps -a --format "table {{.Names}}\t{{.Image}}\t{{.Status}}\t{{.Ports}}"

# List all containers using formatted table (Filter by name)
docker ps -a -f "name=SQL-Plex" --format "table {{.Names}}\t{{.Image}}\t{{.Ports}}\t{{.Status}}"

# Stop container
# Alias version - dkstp SQL-Plex
docker stop SQL-Plex

# Does SQL Server is gracefully stopped when the container is shutdown?
# SIGTERM   This is a generic signal to terminate a program
# SIGKILL   This signal causes the immediate termination of a program

# Start container
# Alias version - dkstrt SQL-Plex
docker start SQL-Plex

# 4- Cleanup
# To force deletion, without stopping the container: 
# docker rm -f SQL-Plex
# Alias version - dkrm SQL-Plex
docker stop SQL-Plex
docker rm SQL-Plex