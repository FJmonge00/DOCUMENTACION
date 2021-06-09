# OA WordPress

Genera los ficheros YAML personalizados en `$LANZADERA/servicio-idenfificador`, llama al lanzador.sh para que sea lanzado en el cluster y envie la notificación email al cliente.

```bash
id=$1
cliente=$2
notificar=$3
email=$4
# Preparar PV
sed "s/name: pv-elcliente-wordpress-id/name: pv-$cliente-wordpress-$id/g" $BASEK8S/wordpress/pv-wordpress.yaml |
sed "s\id: \"1000\"\id: \"$id\"\g" |
sed "s/cliente: elcliente/cliente: $cliente/g" |
sed "s/storageClassName: wordpress-id/storageClassName: wordpress-$id/g" |
sed "s/path: \/home\/wordpress-id/path: \/home\/wordpress-$id/g" > $LANZADERA/wordpress-$id/pv-wordpress.yaml
# Preparar PVC
sed "s/name: pvc-elcliente-wordpress-id/name: pvc-$cliente-wordpress-$id/g" $BASEK8S/wordpress/pvc-wordpress.yaml|
sed "s\id: \"1000\"\id: \"$id\"\g"|
sed "s/cliente: elcliente/cliente: $cliente/g" |
sed "s/storageClassName: wordpress-id/storageClassName: wordpress-$id/g" > $LANZADERA/wordpress-$id/pvc-wordpress.yaml    
# Preparar PV
sed "s/name: pv-elcliente-mysql-id/name: pv-$cliente-mysql-$id/g" $BASEK8S/wordpress/pv-mysql.yaml |
sed "s\id: \"1000\"\id: \"$id\"\g" |
sed "s/cliente: elcliente/cliente: $cliente/g" |
sed "s/storageClassName: mysql-id/storageClassName: mysql-$id/g" |
sed "s/path: \/home\/mysql-id/path: \/home\/mysql-$id/g" > $LANZADERA/wordpress-$id/pv-mysql.yaml
# Preparar PVC
sed "s/name: pvc-elcliente-mysql-id/name: pvc-$cliente-mysql-$id/g" $BASEK8S/wordpress/pvc-mysql.yaml|
sed "s\id: \"1000\"\id: \"$id\"\g"|
sed "s/cliente: elcliente/cliente: $cliente/g" |
sed "s/storageClassName: mysql-id/storageClassName: mysql-$id/g" > $LANZADERA/wordpress-$id/pvc-mysql.yaml
#
# Preparar deploy y servicio
#Contrasena aletoria
contrasena=$(cat /dev/urandom | tr -dc [:upper:][:lower:][:digit:] | head -c32)
# Deploy Wordpress
sed "s/name: wordpress-id/name: wordpress-$id/g" $BASEK8S/wordpress/wordpress-deployment.yaml |
sed "s\id: \"1000\"\id: \"$id\"\g" |
sed "s/cliente: elcliente/cliente: $cliente/g" |
sed "s/value: mysql-id/value: mysql-$id/g" |
sed "s/value: contrasena/value: $contrasena/g" |
sed "s/claimName: pvc-elcliente-wordpress-id/claimName: pvc-$cliente-wordpress-$id/g" > $LANZADERA/wordpress-$id/wordpress-deployment.yaml
# Deploy MySQL
sed "s/name: mysql-id/name: mysql-$id/g" $BASEK8S/wordpress/mysql-deployment.yaml |
sed "s\id: \"1000\"\id: \"$id\"\g" |
sed "s/cliente: elcliente/cliente: $cliente/g" |
sed "s/value: mysql-id/value: mysql-$id/g" |
sed "s/value: contrasena/value: $contrasena/g" |
sed "s/claimName: pvc-elcliente-mysql-id/claimName: pvc-$cliente-mysql-$id/g" > $LANZADERA/wordpress-$id/mysql-deployment.yaml
# Preparacion del Correo Bienvenida
if [ $notificar -gt 0 ]
    then
        cat $CORREO/bienvenida/plantillaServicio.txt > $CORREO/bienvenida/servicios/Bienvenida-$cliente-$id.txt
        # Personalizacion
        sed -i "s/SERVICIO/WordPress/g" $CORREO/bienvenida/servicios/Bienvenida-$cliente-$id.txt |
        sed -i "/USUARIODB/d" $CORREO/bienvenida/servicios/Bienvenida-$cliente-$id.txt
        sed -i "/CONTRASENADB/d" $CORREO/bienvenida/servicios/Bienvenida-$cliente-$id.txt
        sed -i "/SERVIDOR/d" $CORREO/bienvenida/servicios/Bienvenida-$cliente-$id.txt
        cp $BASEK8S/wordpress/lanzar.sh $LANZADERA/wordpress-$id/
        sh $LANZADERA/wordpress-$id/lanzar.sh $id $cliente $notificar $email
    else
        cp $BASEK8S/wordpress/lanzar.sh $LANZADERA/wordpress-$id/
        sh $LANZADERA/wordpress-$id/lanzar.sh $id $cliente $notificar $email
fi
```

## Lanzador Wordpress

```bash
id=$1
cliente=$2
notificar=$3
email=$4
servicio="wordpress"
if [ ! -d /var/log/hosting/clientes/$cliente ]
then
    mkdir -p /var/log/hosting/clientes/$cliente
fi
echo "$(date +"%d-%m-%Y-%R:%S")" >> /var/log/hosting/clientes/$cliente/$servicio-$id
echo "" >> /var/log/hosting/clientes/$cliente/$servicio-$id
echo "Crear pv-mysql | $(date +"%d-%m-%Y-%R:%S")" >> /var/log/hosting/clientes/$cliente/$servicio-$id
kubectl apply -f $LANZADERA/wordpress-$id/pv-mysql.yaml >> /var/log/hosting/clientes/$cliente/$servicio-$id 
echo "Crear pv-wordpress | $(date +"%d-%m-%Y-%R:%S")" >> /var/log/hosting/clientes/$cliente/$servicio-$id
kubectl apply -f $LANZADERA/wordpress-$id/pv-wordpress.yaml >> /var/log/hosting/clientes/$cliente/$servicio-$id 
echo "Crear pvc-mysql | $(date +"%d-%m-%Y-%R:%S")" >> /var/log/hosting/clientes/$cliente/$servicio-$id
kubectl apply -f $LANZADERA/wordpress-$id/pvc-mysql.yaml >> /var/log/hosting/clientes/$cliente/$servicio-$id 
echo "Crear pvc-wordpress | $(date +"%d-%m-%Y-%R:%S")" >> /var/log/hosting/clientes/$cliente/$servicio-$id
kubectl apply -f $LANZADERA/wordpress-$id/pvc-wordpress.yaml >> /var/log/hosting/clientes/$cliente/$servicio-$id 
echo "Crear mysql-deployment | $(date +"%d-%m-%Y-%R:%S")" >> /var/log/hosting/clientes/$cliente/$servicio-$id
kubectl apply -f $LANZADERA/wordpress-$id/mysql-deployment.yaml >> /var/log/hosting/clientes/$cliente/$servicio-$id 
echo "Crear wordpress-deployment | $(date +"%d-%m-%Y-%R:%S")" >> /var/log/hosting/clientes/$cliente/$servicio-$id
kubectl apply -f $LANZADERA/wordpress-$id/wordpress-deployment.yaml >> /var/log/hosting/clientes/$cliente/$servicio-$id 
# echo "-->OK<-- | $(date +"%d-%m-%Y-%R:%S")" >> /var/log/hosting/clientes/$cliente/$servicio-$id
echo "#############################################################################################################" >> /var/log/hosting/clientes/$cliente/$servicio-$id
echo "$(date +"%d-%m-%Y-%R:%S")" >> /var/log/hosting/clientes/$cliente/$servicio-$id 
kubectl get svc -l cliente=$cliente >> /var/log/hosting/clientes/$cliente/$servicio-$id
echo "#############################################################################################################" >> /var/log/hosting/clientes/$cliente/$servicio-$id
echo "" >> /var/log/hosting/clientes/$cliente/$servicio-$id
if [ $notificar -gt 0 ]
    then
        sed -i "s/PAGINAWEB/$IPCLUSTER:$(kubectl get svc $servicio-$id -o yaml | grep nodePort | awk '{print $3}')/g" $CORREO/bienvenida/servicios/Bienvenida-$cliente-$id.txt
        cat $CORREO/bienvenida/servicios/Bienvenida-$cliente-$id.txt | mail -s "Alta Servicio: $servicio-$id" $email
```