# DEMO 2 - Inspecting and monitoring
#   1- Create new SQL container
#   2- Inspect SQL container - detailed information
#   3- Monitoring SQL container resource utilization
#   4- Check SQL Container logs
# -----------------------------------------------------------------------------
#   Reference
#   SQL Server logging on Linux
#   https://docs.docker.com/engine/reference/commandline/logs/
#
#   Docker commands aliases
#   https://www.sqlservercentral.com/articles/creating-aliases-for-most-command-docker-commands
#
#   SQL Server - Advanced configuration
#   https://docs.microsoft.com/en-us/sql/linux/sql-server-linux-performance-best-practices?view=sql-server-ver15#advanced-configuration

# 1- Create new SQL container
docker run \
--name SQL-Plex \
--hostname SQL-Plex \
--env 'ACCEPT_EULA=Y' \
--env 'MSSQL_SA_PASSWORD=_SqLr0ck5_' \
--publish 1400:1433 \
--detach mcr.microsoft.com/mssql/server:2019-CU6-ubuntu-18.04

# 2- Get SQL container detailed information (inspect)
# Use docker inspect
docker inspect SQL-Plex

# Get environment variables
docker inspect --format='{{range .Config.Env}}{{println .}}{{end}}' SQL-Plex

# Get PID and status
docker inspect -f 'PID:{{.State.Pid}} Status:{{.State.Status}}' SQL-Plex

# Get IP address
docker inspect -f 'IP address: {{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' SQL-Plex

# Get port mapping
docker inspect -f '{{range $p, $conf := .NetworkSettings.Ports}} {{$p}} -> {{(index $conf 0).HostPort}} {{end}}' SQL-Plex
docker port SQL-Plex

# Get CPU and memory
docker inspect -f 'CPU Quota: {{.HostConfig.CpuQuota}} Memory Quota: {{.HostConfig.Memory}}' SQL-Plex

# 3- Monitoring SQL container resource utilization
# Get resource utilization
docker stats --all --format "table {{.Name}}\t{{.CPUPerc}}\t{{.MemUsage}}"

# SQL Server on Linux - Memory utilization 📌 👀
# In order to ensure there is enough free physical memory for the Linux Operating System, the SQL Server process 
# uses only 80% of the physical RAM by default.
#
# For some systems which large amount of physical RAM, 20% might be a significant number

# Open settings
code ./DockerSettings.png

# 4- Check SQL Container logs
# Alias version - dklgsf SQL-Plex
# Stop container
docker stop SQL-Plex

# Start container, check the logs while SQL Server starts
docker start SQL-Plex && docker logs SQL-Plex -f

# STDOUT    Standard output, this is where the process outputs will be written on screen
# STDERR    Standard error, it is very related to the standard output and is used in order to display errors