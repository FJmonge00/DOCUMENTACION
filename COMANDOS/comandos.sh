# EDITAR PV
sed "s/name: pv-inerco-wordpress-id/name: pv-$cliente-wordpress-$id/g" pv-wordpress.yaml
sed "s\id: \"1000\"\id: \"$id\"\g" pv-wordpress.yaml
#sed "s\id: \"1000\"\id: "$id"\g" pv-wordpress.yaml ; echo "CORRECTO"
sed "s/cliente: inerco/cliente: $cliente/g" pv-wordpress.yaml ; echo "CORRECTO"
sed "s/storageClassName: wordpress-id/storageClassName: wordpress-$id/g" pv-wordpress.yaml ; echo "CORRECTO"
sed "s/path: \/home\/datos\/wordpress-id/path: \/home\/datos\/wordpress-$id/g" pv-wordpress.yaml ; echo "CORRECTO"
# EDITAR PVC
sed "s/name: pvc-inerco-wordpress-id/name: pvc-$cliente-wordpress-$id/g" pvc-wordpress.yaml
sed "s\id: \"1000\"\id: \"$id\"\g" pvc-wordpress.yaml
#sed "s\id: \"1000\"\id: "$id"\g" pvc-wordpress.yaml ; echo "CORRECTO"
sed "s/cliente: inerco/cliente: $cliente/g" pvc-wordpress.yaml ; echo "CORRECTO"
sed "s/storageClassName: wordpress-id/storageClassName: wordpress-$id/g" pvc-wordpress.yaml ; echo "CORRECTO"
#echo "$(cat /dev/urandom | tr -dc [:upper:][:lower:][:digit:] | head -c24)"
