# DEMO 3 - Client connectivity
#   1- SQL Server folder structure on Linux
#   2- Using docker exec
#   3- Connect through bash (interactive terminal)
#   4- Exploring your SQL Server container
#   5- Network connectivity
#   6- Connect using sqlcmd
#   7- Connect using sqlcmd
#   8- Get SQL Server instance and database properties
#
# -----------------------------------------------------------------------------
#   Reference
#   mssql-conf tool
#   https://docs.microsoft.com/en-us/sql/linux/sql-server-linux-configure-mssql-conf?view=sql-server-ver15
#
#   sqlcmd utility
#   https://docs.microsoft.com/en-us/sql/tools/sqlcmd-utility?view=sql-server-ver15
#
#   Connecting to a SQL Server Docker Container Running in macOS
#   https://www.red-gate.com/simple-talk/sysadmin/containerization/connecting-to-a-sql-server-docker-container-running-in-macos/
#
#   Docker Exec Command With Examples
#   https://devconnected.com/docker-exec-command-with-examples/#Docker_Exec_Interactive_Option_IT
#

# 0- Env variables | demo path
cd ~/Documents/Getting-started-SQLContainers/Demo_04;
SQLCMDPASSWORD="_SqLr0ck5_";
shared_folder=/Users/carlos/Documents/Getting-started-SQLContainers/SQLFiles;

# 1- Create and inspect volume
# docker volume rm vlm_SQL
docker volume create vlm_SQL

# 2- Create new SQL container with volume
docker run \
    --name SQL-Tars \
    --hostname SQL-Tars \
    --env 'ACCEPT_EULA=Y' \
    --env 'MSSQL_SA_PASSWORD=_SqLr0ck5_' \
    --volume vlm_SQL:/var/opt/mssql \
    --volume $shared_folder:/SQLFiles \
    --publish 1401:1433 \
    --detach mcr.microsoft.com/mssql/server:2019-CU6-ubuntu-18.04

# All volumes
docker volume ls

# List volumes attached to my container (Formatted)
clear && \
docker ps -a --format '{{ .ID }}' | xargs -I {} docker inspect -f '{{ .Name }}{{ printf "\n" }}{{ range .Mounts }} {{ printf "\n\t" }}{{ .Type }} {{ if eq .Type "bind" }}{{ .Source }}{{ end }}{{ .Name }} => {{ .Destination }}{{ end }}{{ printf "\n" }}' {}

# List volumes attached to my container (JSON)
docker inspect -f='{{json .Mounts}}' SQL-Tars | python -m json.tool

# List local volumes
docker inspect SQL-Tars | grep -i '"Type": "volume"' -C3 | \
grep -v "Propagation" | sed 's/\--//g; s/\},//g; /^$/d'

# List bind volumes
docker inspect SQL-Tars | grep -i '"Type": "bind"' -C3 | \
grep -v "Propagation" | sed 's/\--//g; s/\},//g; /^$/d'

# Using both volumes
# Connect through bash (interactive terminal)
docker exec -it SQL-Tars "bash"

# Export environment variables
export PATH="$PATH:/opt/mssql-tools/bin";
export SQLCMDPASSWORD="_SqLr0ck5_";

# Navigate to SQLFiles folder
cd /SQLFiles/SQLScripts

# Create database
sqlcmd -U SA -e -i Create_Database.sql

# Check databases
sqlcmd -U SA -Q "SET NOCOUNT ON; SELECT name from sys.databases"

# Restart container
docker stop SQL-Tars
docker start SQL-Tars

# 7- Connect using Azure Data Studio
# ---------------------------------------------------------
# Azure Data Studio step
# ---------------------------------------------------------
# 8- Get SQL Server instance and database properties