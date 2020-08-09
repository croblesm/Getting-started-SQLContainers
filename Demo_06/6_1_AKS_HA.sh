# DEMO 6 - SQL Server HA in Kubernetes
#   1- Check PVC and volume provisioned on Kubernetes
#   2- Connect to SQL Server to create new database
#   3- Simulate failure (delete pod)
#   4- Connect using Azure Data Studio
#   5- Get SQL Server instance and database properties
#   6- Browse Kubernetes dashboard
# -----------------------------------------------------------------------------
# References
#   Kubernetes cheat sheet
#   https://kubernetes.io/docs/reference/kubectl/cheatsheet/
#
#   Kubernetes Dashboard
#   https://github.com/kubernetes/dashboard/blob/master/docs/user/access-control/creating-sample-user.md
#   https://collabnix.com/kubernetes-dashboard-on-docker-desktop-for-windows-2-0-0-3-in-2-minutes/

# 0- Environment variables | demo path
cd ~/Documents/Getting-started-SQLContainers/Demo_06;
sa_password="_EnDur@nc3_";

# 1- Check PVC and volume provisioned on Kubernetes
kubectl describe pvc pvc-data-case
kubectl describe pvc pvc-data-case | grep "Volume:"

# 2- Connect to SQL Server to create new database
# sqlcmd -S localhost,1400 -U SA -P $sa_password -Q "drop database HumanResources;"
sqlcmd -S localhost,1400 -U SA -P $sa_password -Q "set nocount on; select @@servername;"
sqlcmd -S localhost,1400 -U SA -P $sa_password -e -i 4_2_CreateDatabase.sql
sqlcmd -S localhost,1400 -U SA -P $sa_password -h -1 -Q "set nocount on; select name from sys.databases;"

# 3- Simulate failure
cd ~/Documents/Getting-started-SQLContainers/Demo_06;
./6_3_SimulateFailure.sh

# 4- Connect using Azure Data Studio
# --------------------------------------
# Azure Data Studio step
# --------------------------------------
# 5- Get SQL Server instance and database properties

# 6- Browse Kubernetes dashboard
# Deploy Kubernetes dashboard
# Change context to default namespace
kubectl config set-context --current --namespace=default

# Deploy dashboard
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.0.0/aio/deploy/recommended.yaml

# Create admin-user service account (for dashboard)
kubectl apply -f admin-user.yml 

# Change context to case-sql namespace
kubectl config set-context --current --namespace=case-sql

# Initiate dashboard
kubectl proxy

# Connect to dashboard using web browser
http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/

# Get admin-user token to connect dashboard
kubectl -n kubernetes-dashboard describe secret \
    $(kubectl -n kubernetes-dashboard get secret | grep admin-user | awk '{print $1}')