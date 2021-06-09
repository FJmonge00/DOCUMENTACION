# OA Joomla

Genera los ficheros YAML personalizados en `$LANZADERA/servicio-idenfificador`, llama al lanzador.sh para que sea lanzado en el cluster y envie la notificación email al cliente.

```bash
id=$1
cliente=$2
notificar=$3
email=$4
# Preparar PV
sed "s/name: pv-elcliente-drupal-id/name: pv-$cliente-drupal-$id/g" $BASEK8S/drupal/pv-drupal.yaml |
sed "s\id: \"1000\"\id: \"$id\"\g" |
sed "s/cliente: elcliente/cliente: $cliente/g" |
sed "s/storageClassName: drupal-id/storageClassName: drupal-$id/g" |
sed "s/path: \/home\/drupal-id/path: \/home\/drupal-$id/g" > $LANZADERA/drupal-$id/pv-drupal.yaml
# Preparar PVC
sed "s/name: pvc-elcliente-drupal-id/name: pvc-$cliente-drupal-$id/g" $BASEK8S/drupal/pvc-drupal.yaml|
sed "s\id: \"1000\"\id: \"$id\"\g"|
sed "s/cliente: elcliente/cliente: $cliente/g" |
sed "s/storageClassName: drupal-id/storageClassName: drupal-$id/g" > $LANZADERA/drupal-$id/pvc-drupal.yaml    
# Preparar PV
sed "s/name: pv-elcliente-postgres-id/name: pv-$cliente-postgres-$id/g" $BASEK8S/drupal/pv-postgres.yaml |
sed "s\id: \"1000\"\id: \"$id\"\g" |
sed "s/cliente: elcliente/cliente: $cliente/g" |
sed "s/storageClassName: postgres-id/storageClassName: postgres-$id/g" |
sed "s/path: \/home\/postgres-id/path: \/home\/postgres-$id/g" > $LANZADERA/drupal-$id/pv-postgres.yaml
# Preparar PVC
sed "s/name: pvc-elcliente-postgres-id/name: pvc-$cliente-postgres-$id/g" $BASEK8S/drupal/pvc-postgres.yaml|
sed "s\id: \"1000\"\id: \"$id\"\g"|
sed "s/cliente: elcliente/cliente: $cliente/g" |
sed "s/storageClassName: postgres-id/storageClassName: postgres-$id/g" > $LANZADERA/drupal-$id/pvc-postgres.yaml
# Preparar deploy y servicio
#Contrasena aletoria
contrasena=$(cat /dev/urandom | tr -dc [:upper:][:lower:][:digit:] | head -c32)
# Deploy drupal
sed "s/name: drupal-id/name: drupal-$id/g" $BASEK8S/drupal/drupal-deployment.yaml |
sed "s\id: \"1000\"\id: \"$id\"\g" |
sed "s/cliente: elcliente/cliente: $cliente/g" |
sed "s/value: contrasena/value: $contrasena/g" |
sed "s/claimName: pvc-elcliente-drupal-id/claimName: pvc-$cliente-drupal-$id/g" > $LANZADERA/drupal-$id/drupal-deployment.yaml
# Deploy postgres
sed "s/name: postgres-id/name: postgres-$id/g" $BASEK8S/drupal/postgres-deployment.yaml |
sed "s\id: \"1000\"\id: \"$id\"\g" |
sed "s/cliente: elcliente/cliente: $cliente/g" |
sed "s/value: contrasena/value: $contrasena/g" |
sed "s/claimName: pvc-elcliente-postgres-id/claimName: pvc-$cliente-postgres-$id/g" > $LANZADERA/drupal-$id/postgres-deployment.yaml
# Preparacion del Correo Bienvenida
if [ $notificar -gt 0 ]
    then
        cat $CORREO/bienvenida/plantillaServicio.txt > $CORREO/bienvenida/servicios/Bienvenida-$cliente-$id.txt
        # Personalizacion
        sed -i "s/SERVICIO/Drupal/g" $CORREO/bienvenida/servicios/Bienvenida-$cliente-$id.txt
        sed -i "s/USUARIODB/drupal/g" $CORREO/bienvenida/servicios/Bienvenida-$cliente-$id.txt
        sed -i "s/CONTRASENADB/$contrasena/g" $CORREO/bienvenida/servicios/Bienvenida-$cliente-$id.txt
        sed -i "s/SERVIDOR/postgres-$id/g" $CORREO/bienvenida/servicios/Bienvenida-$cliente-$id.txt
        cp $BASEK8S/drupal/lanzar.sh $LANZADERA/drupal-$id/
        sh $LANZADERA/drupal-$id/lanzar.sh $id $cliente $notificar $email
    else
        cp $BASEK8S/drupal/lanzar.sh $LANZADERA/drupal-$id/
        sh $LANZADERA/drupal-$id/lanzar.sh $id $cliente $notificar $email
fi
```

## Lanzador Drupal

```bash
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
```