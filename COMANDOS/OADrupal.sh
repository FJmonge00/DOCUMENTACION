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
        sed -i "s/SERVIDOR/postgres-$id y la base de datos es dbdrupal/g" $CORREO/bienvenida/servicios/Bienvenida-$cliente-$id.txt
        cp $BASEK8S/drupal/lanzar.sh $LANZADERA/drupal-$id/
        sh $LANZADERA/drupal-$id/lanzar.sh $id $cliente $notificar $email
    else
        cp $BASEK8S/drupal/lanzar.sh $LANZADERA/drupal-$id/
        sh $LANZADERA/drupal-$id/lanzar.sh $id $cliente $notificar $email
fi