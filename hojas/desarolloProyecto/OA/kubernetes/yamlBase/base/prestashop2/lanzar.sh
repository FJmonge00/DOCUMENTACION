# Editar fichero
id=$1
cliente=$2
# cliente="inerco"
servicio="prestashop"
if [ ! -d /var/log/hosting/clientes/$cliente ]
then
    mkdir -p /var/log/hosting/clientes/$cliente
fi
echo "$(date +"%Y-%m-%d-%R:%S")" >> /var/log/hosting/clientes/$cliente/$servicio
echo "" >> /var/log/hosting/clientes/$cliente/$servicio
echo "Crear pv-mysql | $(date +"%Y-%m-%d-%R:%S")" >> /var/log/hosting/clientes/$cliente/$servicio
kubectl apply -f $LANZADERA/prestashop-$id/pv-mysql.yaml >> /var/log/hosting/clientes/$cliente/$servicio 
sleep 1s 
echo "Crear pv-prestashop | $(date +"%Y-%m-%d-%R:%S")" >> /var/log/hosting/clientes/$cliente/$servicio
kubectl apply -f $LANZADERA/prestashop-$id/pv-prestashop.yaml >> /var/log/hosting/clientes/$cliente/$servicio 
sleep 1s 
echo "Crear pvc-mysql | $(date +"%Y-%m-%d-%R:%S")" >> /var/log/hosting/clientes/$cliente/$servicio
kubectl apply -f $LANZADERA/prestashop-$id/pvc-mysql.yaml >> /var/log/hosting/clientes/$cliente/$servicio 
sleep 1s 
echo "Crear pvc-prestashop | $(date +"%Y-%m-%d-%R:%S")" >> /var/log/hosting/clientes/$cliente/$servicio
kubectl apply -f $LANZADERA/prestashop-$id/pvc-prestashop.yaml >> /var/log/hosting/clientes/$cliente/$servicio 
sleep 1s 
echo "Crear mysql-deployment | $(date +"%Y-%m-%d-%R:%S")" >> /var/log/hosting/clientes/$cliente/$servicio
kubectl apply -f $LANZADERA/prestashop-$id/mysql-deployment.yaml >> /var/log/hosting/clientes/$cliente/$servicio 
sleep 1s 
echo "Crear prestashop-deployment | $(date +"%Y-%m-%d-%R:%S")" >> /var/log/hosting/clientes/$cliente/$servicio
kubectl apply -f $LANZADERA/prestashop-$id/prestashop-deployment.yaml >> /var/log/hosting/clientes/$cliente/$servicio 
sleep 1s 
# echo "-->OK<-- | $(date +"%Y-%m-%d-%R:%S")" >> /var/log/hosting/clientes/$cliente/$servicio
echo "#############################################################################################################" >> /var/log/hosting/clientes/$cliente/$servicio
echo "$(date +"%Y-%m-%d-%R:%S")" >> /var/log/hosting/clientes/$cliente/$servicio 
kubectl get svc -l cliente=$cliente >> /var/log/hosting/clientes/$cliente/$servicio
echo "#############################################################################################################" >> /var/log/hosting/clientes/$cliente/$servicio
# kubectl delete pvc,pv,svc,deploy -l cliente=$cliente
echo "" >> /var/log/hosting/clientes/$cliente/$servicio
# Datos acceso coger de la Base de datos actualziarla si es necesario
# Guardar datos en e /var/hosting/$cliente/$servicio 