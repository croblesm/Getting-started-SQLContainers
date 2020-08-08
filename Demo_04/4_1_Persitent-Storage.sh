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