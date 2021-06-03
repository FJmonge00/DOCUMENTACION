id=$1
cliente=$2
notificar=$3
email=$4
# echo "OAjoomla $id"
# echo "OAjoomla $cliente"
# cd $BASEK8S/joomla 
# Preparar PV
sed "s/name: pv-elcliente-joomla-id/name: pv-$cliente-joomla-$id/g" $BASEK8S/joomla/pv-joomla.yaml |
sed "s\id: \"1000\"\id: \"$id\"\g" |
sed "s/cliente: elcliente/cliente: $cliente/g" |
sed "s/storageClassName: joomla-id/storageClassName: joomla-$id/g" |
sed "s/path: \/home\/joomla-id/path: \/home\/joomla-$id/g" > $LANZADERA/joomla-$id/pv-joomla.yaml
# Preparar PVC
sed "s/name: pvc-elcliente-joomla-id/name: pvc-$cliente-joomla-$id/g" $BASEK8S/joomla/pvc-joomla.yaml|
sed "s\id: \"1000\"\id: \"$id\"\g"|
sed "s/cliente: elcliente/cliente: $cliente/g" |
sed "s/storageClassName: joomla-id/storageClassName: joomla-$id/g" > $LANZADERA/joomla-$id/pvc-joomla.yaml    
# sed "s/name: pv-elcliente-joomla-id/name: pv-$cliente-joomla-$id/g" pv-mysql.yaml |
# sed "s\id: \"1000\"\id: \"$id\"\g" |
# sed "s/cliente: elcliente/cliente: $cliente/g" |
# sed "s/storageClassName: mysql-id/storageClassName: mysql-$id/g" |
# sed "s/path: \/home\/mysql-id/path: \/home\/mysql-$id/g" > $LANZADERA/joomla-$id/pv-mysql.yaml
# Preparar PV
sed "s/name: pv-elcliente-mysql-id/name: pv-$cliente-mysql-$id/g" $BASEK8S/joomla/pv-mysql.yaml |
sed "s\id: \"1000\"\id: \"$id\"\g" |
sed "s/cliente: elcliente/cliente: $cliente/g" |
sed "s/storageClassName: mysql-id/storageClassName: mysql-$id/g" |
sed "s/path: \/home\/mysql-id/path: \/home\/mysql-$id/g" > $LANZADERA/joomla-$id/pv-mysql.yaml
# Preparar PVC
sed "s/name: pvc-elcliente-mysql-id/name: pvc-$cliente-mysql-$id/g" $BASEK8S/joomla/pvc-mysql.yaml|
sed "s\id: \"1000\"\id: \"$id\"\g"|
sed "s/cliente: elcliente/cliente: $cliente/g" |
sed "s/storageClassName: mysql-id/storageClassName: mysql-$id/g" > $LANZADERA/joomla-$id/pvc-mysql.yaml
#
# Preparar deploy y servicio
#Contrasena aletoria
contrasena=$(cat /dev/urandom | tr -dc [:upper:][:lower:][:digit:] | head -c32)
# Deploy joomla
sed "s/name: joomla-id/name: joomla-$id/g" $BASEK8S/joomla/joomla-deployment.yaml |
sed "s\id: \"1000\"\id: \"$id\"\g" |
sed "s/cliente: elcliente/cliente: $cliente/g" |
sed "s/value: mysql-id/value: mysql-$id/g" |
sed "s/value: contrasena/value: $contrasena/g" |
sed "s/claimName: pvc-elcliente-joomla-id/claimName: pvc-$cliente-joomla-$id/g" > $LANZADERA/joomla-$id/joomla-deployment.yaml
# Deploy MySQL
sed "s/name: mysql-id/name: mysql-$id/g" $BASEK8S/joomla/mysql-deployment.yaml |
sed "s\id: \"1000\"\id: \"$id\"\g" |
sed "s/cliente: elcliente/cliente: $cliente/g" |
sed "s/value: mysql-id/value: mysql-$id/g" |
sed "s/value: contrasena/value: $contrasena/g" |
sed "s/claimName: pvc-elcliente-mysql-id/claimName: pvc-$cliente-mysql-$id/g" > $LANZADERA/joomla-$id/mysql-deployment.yaml
# Preparacion del Correo Bienvenida
if [ $notificar -gt 0 ]
    then
        # cat $CORREO/bienvenida/plantillaServicio.txt > $CORREO/bienvenida/servicios/PRUEBA.txt
        cat $CORREO/bienvenida/plantillaServicio.txt > $CORREO/bienvenida/servicios/Bienvenida-$cliente-$id.txt
        # Personalizacion
        sed -i "s/SERVICIO/Joomla/g" $CORREO/bienvenida/servicios/Bienvenida-$cliente-$id.txt
        sed -i "s/USUARIODB/joomla/g" $CORREO/bienvenida/servicios/Bienvenida-$cliente-$id.txt
        sed -i "s/CONTRASENADB/$contrasena/g" $CORREO/bienvenida/servicios/Bienvenida-$cliente-$id.txt
        sed -i "s/SERVIDOR/mysql-$id/g" $CORREO/bienvenida/servicios/Bienvenida-$cliente-$id.txt
        cp $BASEK8S/joomla/lanzar.sh $LANZADERA/joomla-$id/
        sh $LANZADERA/joomla-$id/lanzar.sh $id $cliente $notificar $email
    else
        cp $BASEK8S/joomla/lanzar.sh $LANZADERA/joomla-$id/
        sh $LANZADERA/joomla-$id/lanzar.sh $id $cliente $notificar $email
fi