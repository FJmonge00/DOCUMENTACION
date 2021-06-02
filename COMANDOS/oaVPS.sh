#!/bin/bash
# Consulta en MariaDB
echo "SELECT id,so,plan,cliente,vcpu,vram,disco FROM vps WHERE fechasolicitud > NOW() - INTERVAL 3 MINUTE" | mariadb -N -B hosting > $SALIDAVPS/salidaVPS.txt
# echo "SELECT id,app,cliente FROM servicios WHERE fecha > NOW() - INTERVAL 3 MINUTE" | mariadb -N -B hosting > $SALIDAVPS/salidaVPS.txt
# Prepara CSV
sed -i 's/\t/,/g' $SALIDAVPS/salidaVPS.txt # Control errores Eliminar Espacios y añadir delimitadores de campo
if [ ! -s $SALIDAVPS/salidaVPS.txt ] # Si no tiene datos (Vacio)
    then
        echo "Ningun VPS en cola: $(date +"%d-%m-%Y-%R:%S")" > $SALIDAVPS/salidaVPS.txt
        echo "Proximo lanzamiento: $(date --date="+3 min" +"%d-%m-%Y-%R:%S")" >> $SALIDAVPS/salidaVPS.txt
    else
        echo "$(date +"%d-%m-%Y-%R:%S")" >> $OAVPSLOG/VPSLanzados.log
        echo "" >> $OAVPSLOG/VPSLanzados.log
        cat $SALIDAVPS/salidaVPS.txt >> $OAVPSLOG/VPSLanzados.log
        echo "" >> $OAVPSLOG/VPSLanzados.log
        while IFS=, read id so plan cliente vcpu vram disco
        do
            ./gruaVPS.sh ${cliente} ${id} ${so} ${vcpu} ${vram} ${disco} ${plan}
            # mkdir $LANZADERA/${app}-${id} # Carpeta base de lanzadera del servicio          
        done < $SALIDAVPS/salidaVPS.txt
fi