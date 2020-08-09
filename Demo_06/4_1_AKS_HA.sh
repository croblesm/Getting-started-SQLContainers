# DEMO 4 - SQL Server HA in AKS
#
#   1- Connect to Kubernetes cluster in AKS
#   2- Get namespaces, nodes, pods and more
#   3- Check PVC and azure disks provisioned on Kubernetes RG
#   4- Check pod events
#   5- Check pod logs
#   6- Get public IP of SQL Server service
#   7- Connect with Azure Data Studio (Azure Data Studio - Optional)
#   8- Connect to SQL Server to create new database
#   9- Simulate failure
#   10- Get SQL Server instance properties (Azure Data Studio - Optional)
#   11- Explore database objects (Azure Data Studio - Optional)
#   12- Browse Kubernetes dashboard
# -----------------------------------------------------------------------------
# References:
#   Kubernetes cheat sheet
#   https://kubernetes.io/docs/reference/kubectl/cheatsheet/
#
#   Azure CLI - Kubernetes
#   https://docs.microsoft.com/en-us/cli/azure/aks?view=azure-cli-latest

# 0- Environment variables | demo path
cd ~/Documents/Getting-started-SQLContainers/Demo_07;
sa_password="_EnDur@nc3_";

# 3- Check PVC and azure disks provisioned on Kubernetes RG
kubectl describe pvc pvc-data-case
kubectl describe pvc pvc-data-case | grep "Volume:"


# 8- Connect to SQL Server to create new database
# sqlcmd -S localhost,1400 -U SA -P $sa_password -Q "drop database HumanResources;"
sqlcmd -S localhost,1400 -U SA -P $sa_password -Q "set nocount on; select @@servername;"
sqlcmd -S localhost,1400 -U SA -P $sa_password -e -i 4_2_CreateDatabase.sql
sqlcmd -S localhost,1400 -U SA -P $sa_password -h -1 -Q "set nocount on; select name from sys.databases;"

# 9- Simulate failure
cd ~/Documents/$resource_group/Demo_04
./4_3_SimulateFailure.sh

# --------------------------------------
# Azure Data Studio step
# --------------------------------------
# 10- Get SQL Server instance properties
# 11- Explore database objects

# 12- Show Kubernetes dashboard

# 1- Deploy Kubernetes dashboard
kubectl config set-context --current --namespace=default
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.0.0/aio/deploy/recommended.yaml

kubectl config set-context --current --namespace=case-sql
kubectl proxy
http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/

kubectl apply -f admin-user.yml 
kubectl -n kubernetes-dashboard describe secret \
    $(kubectl -n kubernetes-dashboard get secret | grep admin-user | awk '{print $1}')