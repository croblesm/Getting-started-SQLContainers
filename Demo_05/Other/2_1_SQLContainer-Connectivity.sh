
https://www.red-gate.com/simple-talk/sysadmin/containerization/connecting-to-a-sql-server-docker-container-running-in-macos/


cd /var/opt/mssql/data
docker network ls
docker ps -a --format "table {{.Names}}\t{{.Image}}\t{{.Status}}\t{{.Ports}}"

sqlcmd -S 192.168.99.100,32673 -U SA -P "20Ye4rsOfP@ss#"

sqlcmd -S <hostname | port number> -U <login> -P <password>

sqlcmd -S localhost -U SA -P "MyP@ssw0rd#" -Q "SET NOCOUNT ON; SELECT name from sys.databases"


# --------------------------------------
# Azure Data Studio step
# --------------------------------------
# 3- Get SQL Server instance properties
# 4- Backup database from source (Azure - Blob)


# All volumes
docker volume ls

# List volumes attached to my container (Formatted)
clear && \
docker ps -a --format '{{ .ID }}' | xargs -I {} docker inspect -f '{{ .Name }}{{ printf "\n" }}{{ range .Mounts }} {{ printf "\n\t" }}{{ .Type }} {{ if eq .Type "bind" }}{{ .Source }}{{ end }}{{ .Name }} => {{ .Destination }}{{ end }}{{ printf "\n" }}' {}

# List volumes attached to my container (JSON)
docker inspect -f='{{json .Mounts}}' demo_01 | python -m json.tool

# List local volumes
docker inspect demo_01 | grep -i '"Type": "volume"' -C3 | \
grep -v "Propagation" | sed 's/\--//g; s/\},//g; /^$/d'

# List bind volumes
docker inspect demo_01 | grep -i '"Type": "bind"' -C3 | \
grep -v "Propagation" | sed 's/\--//g; s/\},//g; /^$/d'

docker exec -it -u root SQL-Plex "bash"
/
└── opt
    └── mssql
        ├── bin
        └── lib
            ├── loc
            └── mssql-conf

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