# Editar fichero
# cliente = ResultadoDelPHPoLABaseDeDatos SELECT nombre from servicio
id=$1
cliente=$2
notificar=$3
email=$4
servicio="drupal"
if [ ! -d /var/log/hosting/clientes/$cliente ]
    then
        mkdir -p /var/log/hosting/clientes/$cliente
fi
echo "$(date +"%Y-%m-%d-%R:%S")" >> /var/log/hosting/clientes/$cliente/$servicio-$id
echo "" >> /var/log/hosting/clientes/$cliente/$servicio-$id
echo "Crear pv-postgres | $(date +"%Y-%m-%d-%R:%S")" >> /var/log/hosting/clientes/$cliente/$servicio-$id
kubectl apply -f $LANZADERA/drupal-$id/pv-postgres.yaml >> /var/log/hosting/clientes/$cliente/$servicio-$id
sleep 1s 
echo "Crear pv-drupal | $(date +"%Y-%m-%d-%R:%S")" >> /var/log/hosting/clientes/$cliente/$servicio-$id
kubectl apply -f $LANZADERA/drupal-$id/pv-drupal.yaml >> /var/log/hosting/clientes/$cliente/$servicio-$id
sleep 1s 
echo "Crear pvc-postgres | $(date +"%Y-%m-%d-%R:%S")" >> /var/log/hosting/clientes/$cliente/$servicio-$id
kubectl apply -f $LANZADERA/drupal-$id/pvc-postgres.yaml >> /var/log/hosting/clientes/$cliente/$servicio-$id
sleep 1s 
echo "Crear pvc-drupal | $(date +"%Y-%m-%d-%R:%S")" >> /var/log/hosting/clientes/$cliente/$servicio-$id
kubectl apply -f $LANZADERA/drupal-$id/pvc-drupal.yaml >> /var/log/hosting/clientes/$cliente/$servicio-$id
sleep 1s 
echo "Crear postgres-deployment | $(date +"%Y-%m-%d-%R:%S")" >> /var/log/hosting/clientes/$cliente/$servicio-$id
kubectl apply -f $LANZADERA/drupal-$id/postgres-deployment.yaml >> /var/log/hosting/clientes/$cliente/$servicio-$id
sleep 1s 
echo "Crear drupal-deployment | $(date +"%Y-%m-%d-%R:%S")" >> /var/log/hosting/clientes/$cliente/$servicio-$id
kubectl apply -f $LANZADERA/drupal-$id/drupal-deployment.yaml >> /var/log/hosting/clientes/$cliente/$servicio-$id
sleep 1s 
# echo "-->OK<-- | $(date +"%Y-%m-%d-%R:%S")" >> /var/log/hosting/clientes/$cliente/$servicio-$id
echo "#############################################################################################################" >> /var/log/hosting/clientes/$cliente/$servicio-$id
echo "$(date +"%Y-%m-%d-%R:%S")" >> /var/log/hosting/clientes/$cliente/$servicio-$id
kubectl get svc -l cliente=$cliente >> /var/log/hosting/clientes/$cliente/$servicio-$id
echo "#############################################################################################################" >> /var/log/hosting/clientes/$cliente/$servicio-$id
echo "" >> /var/log/hosting/clientes/$cliente/$servicio-$id
if [ $notificar -gt 0 ] 
    then
        sed -i "s/PAGINAWEB/$IPCLUSTER:$(kubectl get svc $servicio-$id -o yaml | grep nodePort | awk '{print $3}')/g" $CORREO/bienvenida/servicios/Bienvenida-$cliente-$id.txt
        cat $CORREO/bienvenida/servicios/Bienvenida-$cliente-$id.txt | mail -s "Alta Servicio: $servicio-$id" $email
fi