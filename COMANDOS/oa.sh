#!/bin/bash
# Variables entorno
export OA="/var/lib/oa"
export BASEK8S="/var/lib/oa/Kubernetes/base"
export LANZADERA="/var/lib/oa/Kubernetes/lanzadera"
export OAK8SLOG="/var/log/hosting"
#SCRIPT
# 
#
# Consulta en MariaDB
echo "SELECT id,app,cliente FROM servicios WHERE fecha > NOW() - INTERVAL 3 MINUTE" | mariadb -N -B hosting > $LANZADERA/cola/servicios.csv
# Prepara CSV
sed -i 's/\t/,/g' $LANZADERA/cola/servicios.csv # Control errores Eliminar Espacios
if [ ! -s $LANZADERA/cola/servicios.csv ] # Si no tiene datos (Vacio)
    then
        echo "Ningun servicio en cola: $(date +"%d-%m-%Y-%R:%S")" > $LANZADERA/cola/servicios.csv
        echo "Proximo lanzamiento: $(date --date="+3 min" +"%d-%m-%Y-%R:%S")" >> $LANZADERA/cola/servicios.csv
    else
        echo "$(date +"%d-%m-%Y-%R:%S")" >> $OAK8SLOG/oa/serviciosLanzados.log
        echo "" >> $OAK8SLOG/oa/serviciosLanzados.log
        cat $LANZADERA/cola/servicios.csv >> $OAK8SLOG/oa/serviciosLanzados.log
        echo "" >> $OAK8SLOG/oa/serviciosLanzados.log
        while IFS=, read id app cliente
        do
            mkdir $LANZADERA/${app}-${id} # Carpeta base de lanzadera del servicio
            case ${app} in
                'joomla') sh OAJoomla.sh $id $cliente
                ;;
                'wordpress') sh OAWordpress.sh $id $cliente
                ;;
                'prestashop') sh OAPrestashop.sh $id $cliente
                ;;
                'mediawiki') echo "mediawiki"
                ;;
                'drupal') sh OADrupal.sh $id $cliente
                ;;
                *) echo "Error de lanzamiento: $(date +"%d-%m-%Y-%R:%S")" >> $OAK8SLOG/oa/serviciosLanzados.log
                   echo "Valor de Id: ${id}" >> $OAK8SLOG/oa/serviciosLanzados.log
                   echo "Valor de App: ${app}" >> $OAK8SLOG/oa/serviciosLanzados.log
                   echo "Valor de Cliente: ${cliente}" >> $OAK8SLOG/oa/serviciosLanzados.log
                ;;
            esac
        done < $LANZADERA/cola/servicios.csv
fi