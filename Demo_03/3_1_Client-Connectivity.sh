# DEMO 3 - Client connectivity
#   1- SQL Server folder structure on Linux
#   2- Using docker exec
#   3- Connect through bash (interactive terminal)
#   4- Exploring your SQL Server container
#   5- Network connectivity
#   6- Connect using sqlcmd
#   7- Connect using Azure Data Studio
#   8- Get SQL Server instance and database properties
# -----------------------------------------------------------------------------
# Reference
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

# 0- Env variables | demo path
cd ~/Documents/Getting-started-SQLContainers/Demo_03;
export SQLCMDPASSWORD="_SqLr0ck5_";

# 1- SQL Server folder structure on Linux
# SQL Server binaries (from installation)
/opt
└── mssql
    ├── bin
    └── lib
        ├── loc
        └── mssql-conf

# SQL Server data and log files
/var
└── opt
    └── mssql
        ├── data
        │   ├── master.mdf
        │   ├── mastlog.ldf
        │   ├── model.mdf
        │   ├── modellog.ldf
        │   ├── msdbdata.mdf
        │   ├── msdblog.ldf
        │   ├── tempdb.mdf
        │   ├── tempdb2.ndf
        │   └── templog.ldf
        ├── log
        │   ├── errorlog
        │   ├── errorlog.1
        │   ├── sqlagentstartup.log
        │   ├── log.trc
        │   └── system_health.xel
        └── secrets
            └── machine-key

# 2- Using docker exec
# How docker exec works
# docker exec [options] <container name> <command>

# Few examples
docker exec SQL-Plex hostname
docker exec SQL-Plex /opt/mssql-tools/bin/sqlcmd -?

# 3- Connect through bash (interactive terminal)
docker exec -it SQL-Plex "bash"

# STDIN     Standard input that will be used in order to type and submit your commands from keyboard
# STDOUT    Standard output, this is where the process outputs will be written on screen
# STDERR    Standard error, it is very related to the standard output and is used in order to display errors

# 4- Exploring your SQL Server container
# Navigate to data folder
cd /var/opt/mssql/data

# List all files
ls -l
exit

# 5- Network connectivity
# Check docker network
docker network ls

# Get SQL Server port
docker ps -a --format "table {{.Names}}\t{{.Image}}\t{{.Status}}\t{{.Ports}}"
docker port SQL-Plex

# 6- Connect using sqlcmd
# sqlcmd reference
sqlcmd -S <hostname | port number> -U <login> -P <password>

# Connect to SQL container (SQLPlex)
sqlcmd -S localhost,1401 -U SA -P "_SqLr0ck5_"

# Set SA password as sqlcmd environment variable
SQLCMDPASSWORD="_SqLr0ck5_"

# Connect and execute queries (no SA exposed)
sqlcmd -S localhost,1401 -U SA -h -1 -Q "SET NOCOUNT ON; SELECT name from sys.databases;"
sqlcmd -S localhost,1401 -U SA -h -1 -Q "SET NOCOUNT ON; SELECT @@SERVERNAME;"

# Create database
sqlcmd -S localhost,1401 -U SA -d master -e -i 3_2_Create_Database.sql

# 7- Connect using Azure Data Studio
# ---------------------------------------------------------
# Azure Data Studio step
# ---------------------------------------------------------
# 8- Get SQL Server instance and database properties