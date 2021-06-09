# OA PestaShop

Genera los ficheros YAML personalizados en `$LANZADERA/servicio-idenfificador`, llama al lanzador.sh para que sea lanzado en el cluster y envie la notificación email al cliente.

```bash
id=$1
cliente=$2
notificar=$3
email=$4
# Preparar PV
sed "s/name: pv-elcliente-prestashop-id/name: pv-$cliente-prestashop-$id/g" $BASEK8S/prestashop/pv-prestashop.yaml |
sed "s\id: \"1000\"\id: \"$id\"\g" |
sed "s/cliente: elcliente/cliente: $cliente/g" |
sed "s/storageClassName: prestashop-id/storageClassName: prestashop-$id/g" |
sed "s/path: \/home\/prestashop-id/path: \/home\/prestashop-$id/g" > $LANZADERA/prestashop-$id/pv-prestashop.yaml
# Preparar PVC
sed "s/name: pvc-elcliente-prestashop-id/name: pvc-$cliente-prestashop-$id/g" $BASEK8S/prestashop/pvc-prestashop.yaml|
sed "s\id: \"1000\"\id: \"$id\"\g"|
sed "s/cliente: elcliente/cliente: $cliente/g" |
sed "s/storageClassName: prestashop-id/storageClassName: prestashop-$id/g" > $LANZADERA/prestashop-$id/pvc-prestashop.yaml    
# Preparar PV
sed "s/name: pv-elcliente-mysql-id/name: pv-$cliente-mysql-$id/g" $BASEK8S/prestashop/pv-mysql.yaml |
sed "s\id: \"1000\"\id: \"$id\"\g" |
sed "s/cliente: elcliente/cliente: $cliente/g" |
sed "s/storageClassName: mysql-id/storageClassName: mysql-$id/g" |
sed "s/path: \/home\/mysql-id/path: \/home\/mysql-$id/g" > $LANZADERA/prestashop-$id/pv-mysql.yaml
# Preparar PVC
sed "s/name: pvc-elcliente-mysql-id/name: pvc-$cliente-mysql-$id/g" $BASEK8S/prestashop/pvc-mysql.yaml|
sed "s\id: \"1000\"\id: \"$id\"\g"|
sed "s/cliente: elcliente/cliente: $cliente/g" |
sed "s/storageClassName: mysql-id/storageClassName: mysql-$id/g" > $LANZADERA/prestashop-$id/pvc-mysql.yaml
#
# Preparar deploy y servicio
#Contrasena aletoria
contrasena=$(cat /dev/urandom | tr -dc [:upper:][:lower:][:digit:] | head -c32)
# Deploy prestashop
sed "s/name: prestashop-id/name: prestashop-$id/g" $BASEK8S/prestashop/prestashop-deployment.yaml |
sed "s\id: \"1000\"\id: \"$id\"\g" |
sed "s/cliente: elcliente/cliente: $cliente/g" |
sed "s/value: mysql-id/value: mysql-$id/g" |
sed "s/value: admin-id/value: admin-$id/g" |
sed "s/value: contrasena/value: $contrasena/g" |
sed "s/claimName: pvc-elcliente-prestashop-id/claimName: pvc-$cliente-prestashop-$id/g" > $LANZADERA/prestashop-$id/prestashop-deployment.yaml
# Deploy MySQL
sed "s/name: mysql-id/name: mysql-$id/g" $BASEK8S/prestashop/mysql-deployment.yaml |
sed "s\id: \"1000\"\id: \"$id\"\g" |
sed "s/cliente: elcliente/cliente: $cliente/g" |
sed "s/value: mysql-id/value: mysql-$id/g" |
sed "s/value: contrasena/value: $contrasena/g" |
sed "s/claimName: pvc-elcliente-mysql-id/claimName: pvc-$cliente-mysql-$id/g" > $LANZADERA/prestashop-$id/mysql-deployment.yaml
# Preparacion del Correo Bienvenida
if [ $notificar -gt 0 ]
    then
        cat $CORREO/bienvenida/plantillaServicio.txt > $CORREO/bienvenida/servicios/Bienvenida-$cliente-$id.txt
        # Personalizacion
        sed -i "s/SERVICIO/PrestaShop/g" $CORREO/bienvenida/servicios/Bienvenida-$cliente-$id.txt
        sed -i "s/USUARIODB/prestashop/g" $CORREO/bienvenida/servicios/Bienvenida-$cliente-$id.txt
        sed -i "s/CONTRASENADB/$contrasena/g" $CORREO/bienvenida/servicios/Bienvenida-$cliente-$id.txt
        sed -i "s/SERVIDOR/mysql-$id/g" $CORREO/bienvenida/servicios/Bienvenida-$cliente-$id.txt
        cp $BASEK8S/prestashop/lanzar.sh $LANZADERA/prestashop-$id/
        sh $LANZADERA/prestashop-$id/lanzar.sh $id $cliente $notificar $email
    else
        cp $BASEK8S/prestashop/lanzar.sh $LANZADERA/prestashop-$id/
        sh $LANZADERA/prestashop-$id/lanzar.sh $id $cliente $notificar $email
fi
```

## Lanzador PrestaShop

```bash
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
```