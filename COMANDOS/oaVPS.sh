#!/bin/bash
# Consulta en MariaDB
echo "SELECT id,so,plan,cliente,vcpu,vram,disco,notificar,email FROM vps WHERE fechasolicitud > NOW() - INTERVAL 3 MINUTE" | mariadb -N -B hosting > $SALIDAVPS/salidaVPS.txt
# Prepara CSV
sed -i 's/\t/,/g' $SALIDAVPS/salidaVPS.txt # Control errores Eliminar Espacios y añadir delimitadores de campo
if [ ! -s $SALIDAVPS/salidaVPS.txt ] # Si no tiene datos (Vacio)
    then
        echo "Ningun VPS en cola: $(date +"%d-%m-%Y-%R:%S")" > $SALIDAVPS/salidaVPS.txt
        echo "Proximo lanzamiento: $(date --date="+3 min" +"%d-%m-%Y-%R:%S")" >> $SALIDAVPS/salidaVPS.txt
    else
        echo '[salidaVPS]' > $SALIDAVPS/salidaVPS.conf
        echo "$(date +"%d-%m-%Y-%R:%S")" >> $OAVPSLOG/VPSLanzados.log
        echo "" >> $OAVPSLOG/VPSLanzados.log
        cat $SALIDAVPS/salidaVPS.txt >> $OAVPSLOG/VPSLanzados.log
        echo "" >> $OAVPSLOG/VPSLanzados.log
        while IFS=, read id so plan cliente vcpu vram disco notificar email
        do
            if [ ! $so == 'WindowsServer2019' ] 
                then
                    ./gruaVPS.sh ${cliente} ${id} ${so} ${vcpu} ${vram} ${disco} ${plan} ${notificar} ${email}        
                    case ${so} in
                        'Debian10') 
                            if [ $plan == 'DockerDesarollo' ] 
                                then
                                    ansible-playbook -i $SALIDAVPS/salidaVPS.conf $plan-$so.yaml 2> /dev/null 1>> $OAVPSLOG/$cliente/$cliente-$id/preparacion.log
                                else
                                    ansible-playbook -i $SALIDAVPS/salidaVPS.conf $plan.yaml 2> /dev/null 1>> $OAVPSLOG/$cliente/$cliente-$id/preparacion.log
                            fi
                        ;;
                        'UbuntuServer2004') 
                            if [ $plan == 'DockerDesarollo' ] 
                                then
                                    ansible-playbook -i $SALIDAVPS/salidaVPS.conf $plan-$so.yaml 2> /dev/null 1>> $OAVPSLOG/$cliente/$cliente-$id/preparacion.log
                                else
                                    ansible-playbook -i $SALIDAVPS/salidaVPS.conf $plan.yaml 2> /dev/null 1>> $OAVPSLOG/$cliente/$cliente-$id/preparacion.log
                            fi
                        ;;
                        *)
                        ;;
                    esac
                else
                    ./gruaVPSWindows.sh ${cliente} ${id} ${so} ${vcpu} ${vram} ${disco} ${plan} ${notificar} ${email}
            fi
            echo "UPDATE vps SET fechapreparada = (CURRENT_TIMESTAMP) WHERE id = $id" | mariadb -N -B hosting 2>> $OAVPSLOG/$cliente/$cliente-$id/preparacion.log
        done < $SALIDAVPS/salidaVPS.txt
fi