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
# sed "s/name: pv-elcliente-prestashop-id/name: pv-$cliente-prestashop-$id/g" pv-mysql.yaml |
# sed "s\id: \"1000\"\id: \"$id\"\g" |
# sed "s/cliente: elcliente/cliente: $cliente/g" |
# sed "s/storageClassName: mysql-id/storageClassName: mysql-$id/g" |
# sed "s/path: \/home\/mysql-id/path: \/home\/mysql-$id/g" > $LANZADERA/prestashop-$id/pv-mysql.yaml
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