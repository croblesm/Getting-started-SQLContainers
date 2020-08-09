# DEMO 4 - SQL Server - AKS deployment
#   SQL Server deployment in AKS
#
#   1- Create namespace, secret, pvc, service and SQL Server
#   2- Check namespace, secret, pvc, service and pod
#   3- Check pod logs
#   4- Get service IP
#   5- Test connectivity through queries
# -----------------------------------------------------------------------------
# References:
#   Kubernetes cheat sheet
#   https://kubernetes.io/docs/reference/kubectl/cheatsheet/
#
#   Deploy a SQL Server container in Kubernetes with Azure Kubernetes Services (AKS)
#   https://docs.microsoft.com/en-us/sql/linux/tutorial-sql-server-containers-kubernetes?view=sql-server-ver15
#   Kubernetes Dashboard
#   https://github.com/kubernetes/dashboard/blob/master/docs/user/access-control/creating-sample-user.md
#   https://collabnix.com/kubernetes-dashboard-on-docker-desktop-for-windows-2-0-0-3-in-2-minutes/

# 0- Env variables | demo path
resource_group=Microsoft-Reactor;
cd ~/Documents/$resource_group/Demo_04;
sa_password="_EnDur@nc3_";

# 1- Create namespace, secret, pvc, service and SQL Server
kubectl create namespace plex-sql
kubectl config set-context --current --namespace=plex-sql
kubectl config get-contexts
kubectl create secret generic plex-cred --from-literal=SA_PASSWORD="_EnDur@nc3_"
kubectl apply -f ./persistent-volumes/pvc-data-plex.yaml
kubectl apply -f ./services/srvc-sql-plex.yaml
kubectl apply -f ./deployments/depl-sql-plex.yaml --record

# 2- Check namespace, secret, pvc, service and pod
kubectl get pvc --namespace=plex-sql
kubectl get services --namespace=plex-sql
kubectl get pods --namespace=plex-sql
pod=`kubectl get pods | grep mssql-plex-deployment | awk {'print $1'}`
kubectl describe pods $pod

# 3- Check pod logs
kubectl logs $pod -f

# 4- Get service IP
kubectl get service mssql-plex-service
plex_service=`kubectl get service mssql-plex-service | grep mssql-plex | awk {'print $4'}`

# 5- Test connectivity through queries
sqlcmd -S $plex_service,1400 -U SA -P $sa_password -Q "set nocount on; select @@servername;"
sqlcmd -S $plex_service,1400 -U SA -P $sa_password -Q "set nocount on; select @@version;"

# 1- Create namespace, secret, pvc, service and SQL Server
kubectl create namespace tars-sql
kubectl config set-context --current --namespace=tars-sql
kubectl create secret generic tars-cred --from-literal=SA_PASSWORD="_EnDur@nc3_"
kubectl apply -f ./persistent-volumes/pvc-data-tars.yaml
kubectl apply -f ./services/srvc-sql-tars.yaml
kubectl apply -f ./deployments/depl-sql-tars.yaml --record

# 2- Check namespace, secret, pvc, service and pod
kubectl get pvc --namespace=tars-sql
kubectl get services --namespace=tars-sql
kubectl get pods --namespace=tars-sql
pod=`kubectl get pods | grep mssql-tars-deployment | awk {'print $1'}`
kubectl describe pods $pod

# 3- Check pod logs
kubectl logs $pod -f

# 4- Get service IP
kubectl get service mssql-tars-service --watch
tars_service=`kubectl get service mssql-tars-service | grep mssql-tars | awk {'print $4'}`

# 5- Test connectivity through queries
sqlcmd -S $tars_service,1401 -U SA -P $sa_password -Q "set nocount on; select @@servername;"
sqlcmd -S $tars_service,1401 -U SA -P $sa_password -Q "set nocount on; select @@version;"

# ==============================================================================================================


# kubectl apply -f pvc-data-case.yaml
# kubectl get pvc pvc-data-case
# kubectl describe pvc pvc-data-case

resource_group=Microsoft-Reactor;
cd ~/Documents/$resource_group/Demo_04;
sa_password="_EnDur@nc3_";

# 0- Set Kubernetes context to Docker desktop
kubectl config get-context
kubectl config use-context docker-desktop

# 1- Create namespace, secret, pvc, service and SQL Server
kubectl create namespace case-sql
kubectl config set-context --current --namespace=case-sql
kubectl config get-contexts

kubectl create secret generic case-cred --from-literal=SA_PASSWORD="_EnDur@nc3_"
kubectl apply -f ./persistent-volumes/pvc-data-case.yaml
kubectl apply -f ./services/srvc-sql-case.yaml
kubectl apply -f ./deployments/depl-sql-case.yaml --record

# 2- Check namespace, secret, pvc, service and pod
kubectl get pvc --namespace=case-sql
kubectl get services --namespace=case-sql
kubectl get pods --namespace=case-sql
pod=`kubectl get pods | grep mssql-case-deployment | awk {'print $1'}`
kubectl describe pods $pod

# 3- Check pod logs
kubectl logs $pod -f

docker stats --all --format "table {{.Container}}\t{{.CPUPerc}}\t{{.MemUsage}}"

# 5- Test connectivity through queries
sqlcmd -S localhost,1400 -U SA -h -1 -P $sa_password -Q "set nocount on; select @@servername;"
sqlcmd -S localhost,1400 -U SA -h -1 -P $sa_password -Q "set nocount on; select @@version;"

kubectl config set-context --current --namespace=default
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.0.0/aio/deploy/recommended.yaml

kubectl config set-context --current --namespace=case-sql
kubectl proxy
http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/

kubectl apply -f admin-user.yml 
kubectl -n kubernetes-dashboard describe secret \
    $(kubectl -n kubernetes-dashboard get secret | grep admin-user | awk '{print $1}')