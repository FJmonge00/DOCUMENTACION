cliente="elcliente"
servicio="mediawiki"
if [ ! -d /var/log/hosting/clientes/$cliente ]
then
    mkdir -p /var/log/hosting/clientes/$cliente
fi
echo "$(date +"%Y-%m-%d-%R:%S")" >> /var/log/hosting/clientes/$cliente/$servicio
echo "" >> /var/log/hosting/clientes/$cliente/$servicio
echo "Crear pv-mysql | $(date +"%Y-%m-%d-%R:%S")" >> /var/log/hosting/clientes/$cliente/$servicio
kubectl apply -f pv-mysql.yaml >> /var/log/hosting/clientes/$cliente/$servicio 
sleep 1s 
echo "Crear pv-mediawiki | $(date +"%Y-%m-%d-%R:%S")" >> /var/log/hosting/clientes/$cliente/$servicio
kubectl apply -f pv-mediawiki.yaml >> /var/log/hosting/clientes/$cliente/$servicio 
sleep 1s 
echo "Crear pvc-mysql | $(date +"%Y-%m-%d-%R:%S")" >> /var/log/hosting/clientes/$cliente/$servicio
kubectl apply -f pvc-mysql.yaml >> /var/log/hosting/clientes/$cliente/$servicio 
sleep 1s 
echo "Crear pvc-mediawiki | $(date +"%Y-%m-%d-%R:%S")" >> /var/log/hosting/clientes/$cliente/$servicio
kubectl apply -f pvc-mediawiki.yaml >> /var/log/hosting/clientes/$cliente/$servicio 
sleep 1s 
echo "Crear mysql-deployment | $(date +"%Y-%m-%d-%R:%S")" >> /var/log/hosting/clientes/$cliente/$servicio
kubectl apply -f mysql-deployment.yaml >> /var/log/hosting/clientes/$cliente/$servicio 
sleep 1s 
echo "Crear mediawiki-deployment | $(date +"%Y-%m-%d-%R:%S")" >> /var/log/hosting/clientes/$cliente/$servicio
kubectl apply -f mediawiki-deployment.yaml >> /var/log/hosting/clientes/$cliente/$servicio 
sleep 1s 
# echo "-->OK<-- | $(date +"%Y-%m-%d-%R:%S")" >> /var/log/hosting/clientes/$cliente/$servicio
echo "#############################################################################################################" >> /var/log/hosting/clientes/$cliente/$servicio
echo "$(date +"%Y-%m-%d-%R:%S")" >> /var/log/hosting/clientes/$cliente/$servicio 
kubectl get svc -l cliente=$cliente >> /var/log/hosting/clientes/$cliente/$servicio
echo "#############################################################################################################" >> /var/log/hosting/clientes/$cliente/$servicio
# kubectl delete pvc,pv,svc,deploy -l cliente=$cliente
echo "" >> /var/log/hosting/clientes/$cliente/$servicio