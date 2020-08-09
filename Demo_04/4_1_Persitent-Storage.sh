# DEMO 4 - Persitent storage (data) with Docker volumes
#   1- SQL Server folder structure on Linux
#   2- Create new SQL container with local and bind volumes
#   3- Inspect SQL container volumes
#   4- Use local and bind volumes
#   5- Restart SQL container
#   6- Check persistent storage
#   7- Connect using Azure Data Studio
#   8- Get SQL Server instance and database properties
# -----------------------------------------------------------------------------

# 0- Env variables | demo path
cd ~/Documents/Getting-started-SQLContainers/Demo_04;
SQLCMDPASSWORD="_SqLr0ck5_";
SQLFiles=~/Documents/Getting-started-SQLContainers/SQLFiles;
# docker volume rm vlm_SQL
# dkrm SQL-Tars

# 1- Create and inspect local and bind volume
# Create local volume (Docker)
docker volume create vlm_SQL
docker inspect vlm_SQL

# SQLFiles folder structure
SQLFiles
├── SQLBackups
│   └── MyBackup.bak
└── SQLScripts
    └── Create_Database.sql

# 2- Create new SQL container with local and bind volumes
docker run \
    --name SQL-Tars \
    --hostname SQL-Tars \
    --env 'ACCEPT_EULA=Y' \
    --env 'MSSQL_SA_PASSWORD=_SqLr0ck5_' \
    --volume vlm_SQL:/var/opt/mssql \
    --volume $SQlFiles:/SQLFiles \
    --publish 1402:1433 \
    --detach mcr.microsoft.com/mssql/server:2019-CU6-ubuntu-18.04

# 3- Inspect SQL container volumes
# All volumes
docker volume ls

# List volumes attached to my container (Formatted)
clear && \
docker ps -a --filter "name=SQL-Tars" \
    --format '{{ .ID }}' | xargs -I {} docker inspect -f \
        '{{ .Name }}{{ printf "\n" }}{{ range .Mounts }} {{ printf "\n\t" }}{{ .Type }} {{ if eq .Type "bind" }}{{ .Source }}{{ end }}{{ .Name }} => {{ .Destination }}{{ end }}{{ printf "\n" }}' {}

# List volumes attached to my container (JSON)
docker inspect -f='{{json .Mounts}}' SQL-Tars | python -m json.tool

# List local volumes
docker inspect SQL-Tars | grep -i '"Type": "volume"' -C3 | \
grep -v "Propagation" | sed 's/\--//g; s/\},//g; /^$/d'

# List bind volumes
docker inspect SQL-Tars | grep -i '"Type": "bind"' -C3 | \
grep -v "Propagation" | sed 's/\--//g; s/\},//g; /^$/d'

# Use both volumes
# Connect through bash (interactive terminal)
docker exec -it SQL-Tars "bash"

# 4- Use local and bind volumes
export PATH="$PATH:/opt/mssql-tools/bin";
export SQLCMDPASSWORD="_SqLr0ck5_";

# Navigate to SQLFiles folder
cd /SQLFiles/SQLScripts

# Create database
#sqlcmd -U SA -h -1 -Q "SET NOCOUNT ON; DROP DATABASE HumanResources;"
sqlcmd -U SA -e -i Create_Database.sql

# Check databases
sqlcmd -U SA -h -1 -Q "SET NOCOUNT ON; SELECT name from sys.databases;"

# 5- Restart SQL container
docker stop SQL-Tars
docker start SQL-Tars

# 6- Check persistent storage
docker volume ls
docker inspect vlm_Data

# 7- Connect using Azure Data Studio
# ---------------------------------------------------------
# Azure Data Studio step
# ---------------------------------------------------------
# 8- Get SQL Server instance and database properties