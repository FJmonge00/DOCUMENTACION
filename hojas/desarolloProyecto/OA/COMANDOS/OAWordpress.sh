id=$1
cliente=$2
notificar=$3
email=$4
# echo "OAWordpress $id"
# echo "OAWordpress $cliente"
# cd $BASEK8S/wordpress 
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
# sed "s/name: pv-elcliente-wordpress-id/name: pv-$cliente-wordpress-$id/g" pv-mysql.yaml |
# sed "s\id: \"1000\"\id: \"$id\"\g" |
# sed "s/cliente: elcliente/cliente: $cliente/g" |
# sed "s/storageClassName: mysql-id/storageClassName: mysql-$id/g" |
# sed "s/path: \/home\/mysql-id/path: \/home\/mysql-$id/g" > $LANZADERA/wordpress-$id/pv-mysql.yaml
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