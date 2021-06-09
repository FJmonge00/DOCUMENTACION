# Editar fichero
id=$1
cliente=$2
notificar=$3
email=$4
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
echo "" >> /var/log/hosting/clientes/$cliente/$servicio
if [ $notificar -gt 0 ] 
    then
        sed -i "s/PAGINAWEB/$IPCLUSTER:$(kubectl get svc $servicio-$id -o yaml | grep nodePort | awk '{print $3}') (El panel de administracion es: $IPCLUSTER:$(kubectl get svc $servicio-$id -o yaml | grep nodePort | awk '{print $3}')\/admin-$id/g" $CORREO/bienvenida/servicios/Bienvenida-$cliente-$id.txt
        cat $CORREO/bienvenida/servicios/Bienvenida-$cliente-$id.txt | mail -s "Alta Servicio: $servicio-$id" $email
fi