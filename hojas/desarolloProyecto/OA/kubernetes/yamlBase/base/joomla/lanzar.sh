# Editar fichero
id=$1
cliente=$2
notificar=$3
email=$4
servicio="joomla"
if [ ! -d /var/log/hosting/clientes/$cliente ]
then
    mkdir -p /var/log/hosting/clientes/$cliente
fi
echo "$(date +"%d-%m-%Y-%R:%S")" >> /var/log/hosting/clientes/$cliente/$servicio-$id
echo "" >> /var/log/hosting/clientes/$cliente/$servicio-$id
echo "Crear pv-mysql | $(date +"%d-%m-%Y-%R:%S")" >> /var/log/hosting/clientes/$cliente/$servicio-$id
kubectl apply -f $LANZADERA/joomla-$id/pv-mysql.yaml >> /var/log/hosting/clientes/$cliente/$servicio-$id 
echo "Crear pv-joomla | $(date +"%d-%m-%Y-%R:%S")" >> /var/log/hosting/clientes/$cliente/$servicio-$id
kubectl apply -f $LANZADERA/joomla-$id/pv-joomla.yaml >> /var/log/hosting/clientes/$cliente/$servicio-$id 
echo "Crear pvc-mysql | $(date +"%d-%m-%Y-%R:%S")" >> /var/log/hosting/clientes/$cliente/$servicio-$id
kubectl apply -f $LANZADERA/joomla-$id/pvc-mysql.yaml >> /var/log/hosting/clientes/$cliente/$servicio-$id 
echo "Crear pvc-joomla | $(date +"%d-%m-%Y-%R:%S")" >> /var/log/hosting/clientes/$cliente/$servicio-$id
kubectl apply -f $LANZADERA/joomla-$id/pvc-joomla.yaml >> /var/log/hosting/clientes/$cliente/$servicio-$id 
echo "Crear mysql-deployment | $(date +"%d-%m-%Y-%R:%S")" >> /var/log/hosting/clientes/$cliente/$servicio-$id
kubectl apply -f $LANZADERA/joomla-$id/mysql-deployment.yaml >> /var/log/hosting/clientes/$cliente/$servicio-$id 
echo "Crear joomla-deployment | $(date +"%d-%m-%Y-%R:%S")" >> /var/log/hosting/clientes/$cliente/$servicio-$id
kubectl apply -f $LANZADERA/joomla-$id/joomla-deployment.yaml >> /var/log/hosting/clientes/$cliente/$servicio-$id 
# echo "-->OK<-- | $(date +"%d-%m-%Y-%R:%S")" >> /var/log/hosting/clientes/$cliente/$servicio-$id
echo "#############################################################################################################" >> /var/log/hosting/clientes/$cliente/$servicio-$id
echo "$(date +"%d-%m-%Y-%R:%S")" >> /var/log/hosting/clientes/$cliente/$servicio-$id 
kubectl get svc -l cliente=$cliente >> /var/log/hosting/clientes/$cliente/$servicio-$id
echo "#############################################################################################################" >> /var/log/hosting/clientes/$cliente/$servicio-$id
echo "" >> /var/log/hosting/clientes/$cliente/$servicio-$id
# echo "Soy el lanzador"
if [ $notificar -gt 0 ] 
    then
        sed -i "s/PAGINAWEB/$IPCLUSTER:$(kubectl get svc $servicio-$id -o yaml | grep nodePort | awk '{print $3}')/g" $CORREO/bienvenida/servicios/Bienvenida-$cliente-$id.txt
        cat $CORREO/bienvenida/servicios/Bienvenida-$cliente-$id.txt | mail -s "Alta Servicio: $servicio-$id" $email
fi