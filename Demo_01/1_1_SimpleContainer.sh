# DEMO 1 - Basic container
#   1- Get SQL Server image list from MCR (Microsoft Container registry)
#   2- Create new SQL container
#   3- Basic container management commands
#   4- Cleanup
# -----------------------------------------------------------------------------
#   Reference
#   SQL Server logging on Linux
#   https://blog.dbi-services.com/sql-server-on-linux-and-logging/
#
#   Docker commands aliases
#   https://www.sqlservercentral.com/articles/creating-aliases-for-most-command-docker-commands
#

# 1- Get SQL Server image list from MCR (Microsoft Container registry)
# Ubuntu based images
curl -s -L https://mcr.microsoft.com/v2/mssql/server/tags/list/

### Powershell 👇 🔌🐚
# pwsh -c "(Invoke-WebRequest -URI https://mcr.microsoft.com/v2/mssql/server/tags/list/).content"

# RHEL based images
curl -s -L https://mcr.microsoft.com/v2/mssql/rhel/server/tags/list/

### Powershell 👇 🔌🐚
# pwsh -c "(Invoke-WebRequest -URI https://mcr.microsoft.com/v2/mssql/rhel/server/tags/list/).content"

# 2- Create new SQL container
docker run \
--name SQL-Plex \
--hostname SQL-Plex \
--env 'ACCEPT_EULA=Y' \
--env 'MSSQL_SA_PASSWORD=SqLr0ck$!' \
--publish 1400:1433 \
--detach mcr.microsoft.com/mssql/server:2019-CU6-ubuntu-18.04

# 3- Basic container management commands
### Docker aliases 🐳 📝 
### SQL Server Central Article 👇 👍
### https://bit.ly/2wcxEJj

# Get status of all containers
# Alias version - dkpsa
# Active containers
docker ps

# All containers
docker ps -a

# All containers using formatted table - By name, image and status
docker ps -a --format "table {{.Names}}\t{{.Image}}\t{{.Status}}"
docker ps -a --format "table {{.Names}}\t{{.Image}}\t{{.Status}}\t{{.Ports}}"
docker ps -a -f "name=SQL-Plex" --format "table {{.Names}}\t{{.Image}}\t{{.Ports}}\t{{.Status}}"

# Stop container
# Alias version - dkstp SQL-Plex
docker stop SQL-Plex

# Start container
# Alias version - dkstrt SQL-Plex
docker start SQL-Plex

# Check container logs
# Alias version - dklgsf SQL-Plex
docker logs SQL-Plex -f

# 4- Cleanup
# To force deletion, without stopping the container: 
# docker rm -f SQL-Plex
# Alias version - dkrm SQL-Plex
docker stop SQL-Plex
docker rm SQL-Plex