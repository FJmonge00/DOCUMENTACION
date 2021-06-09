# OA VPS

Se compone de los siguientes programas:

- ***`oaVPS.sh`***: Busca en la base de datos la existencia de nuevos VPS para levantar, crea las entradas en `$SALIDAVPS/salidaVPS.txt` y `$SALIDAVPS/salidaVPS.conf`  con los parámetros y plan de el VPS y llama a `gruaVPS.sh` (Para Máquinas Linux) o `gruaVPSWindows.sh` (Para las máquinas Windows) para que estas levanten las máquinas y continuen el proceso de crear VPS. Una vez creada la máquina, lanza el PlayBook correspondiente de Ansible según el plan o entorno elegido guardando los Logs de salida o lanzamiento de los VPS en `$OAVPSLOG/$cliente/$cliente-$id/preparacion.log` y crea la entrada Fecha-Hora en la Base de datos cuando la máquina esta disponible.

- ***`gruaVPS.sh`***: Toma la máquina base de `$BASEVPS` y la clona en `$VPS`, una vez que esta clonada le realiza el `virt-sysprep` limpiando y generando toda las configuraciones, usuarios, hash, claves ssh, y entidades unicas que pueda tener esta máquina y generando unas nuevas. Todo esto es realizado sin arrancar la máquina en ningún momento. Posteriormente configura el hardware según los parámetros indicados por `oaVPS.sh` provenientes de la Base de Datos, arranca el VPS y envia una notificacion de bienvenida con los datos de acceso al cliente via email bajo el dominio topserver@gmail.com.

*FUENTE OFICIAL: https://libguestfs.org*

> "Sysprep" significa herramienta de "preparación del sistema". El nombre proviene del programa de Microsoft sysprep.exe que se utiliza para desconfigurar las máquinas con Windows en preparación para su clonación. Dicho esto, virt-sysprep no funciona actualmente en invitados de Microsoft Windows. Planeamos admitir la preparación del sistema de Windows en una versión futura, y ya tenemos código para hacerlo.

En el caso de Windows no es posible realizar el sysprep con KVM en otros hipervisores más optimizados con Windows como es VMware ESXI o Hyper-V. Podemos realizarlo de manera nativa. 

Dicho esto:

- ***`gruaVPSWindows.sh`***: Toma la máquina base de `$BASEVPS` y la clona en `$VPS`. Posteriormente configura el hardware según los parámetros indicados por `oaVPS.sh` provenientes de la Base de Datos, arranca el VPS y envia una notificacion de bienvenida con los datos de acceso al cliente via email bajo el dominio topserver@gmail.com.

>Pára poder clonar las máquinas sin que existan conflictos o información repetida entre ellas se realiza el `sysprep.exe` en la máquina base y esta se clona una vez que se ha ejecutado el `sysprep.exe` limpiando y generando toda las configuraciones, usuarios, hash, claves ssh, y entidades unicas que pueda tener Windows y generando unas nuevas en el arranque.

## Script `oaVPS.sh`

```bash
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
```

## Script `gruaVPS.sh`

```bash
#!/bin/bash
cliente=$1
id=$2
so=$3
vCPU=$4
vRAM=$5
disco=$6
Plan=$7
notificar=$8
email=$9
contrasena=$(cat /dev/urandom | tr -dc [:upper:][:lower:][:digit:] | head -c32)
# contrasena=Coria21
if [ ! -d $OAVPSLOG/$cliente ]
    then
        mkdir -p $OAVPSLOG/$cliente
        chown franadmin:franadmin -R $OAVPSLOG/$cliente
        if [ ! -d $OAVPSLOG/$cliente/$cliente-$id ]
            then
                mkdir -p $OAVPSLOG/$cliente/$cliente-$id
        fi
    else
        if [ ! -d $OAVPSLOG/$cliente/$cliente-$id ]
            then
                mkdir -p $OAVPSLOG/$cliente/$cliente-$id
        fi
fi
echo "$(date +"%d-%m-%Y-%R:%S")" 2> /dev/null 1>> $OAVPSLOG/$cliente/$cliente-$id/preparacion.log
echo "$cliente-$id" >> datos.txt 2> /dev/null 1>> $OAVPSLOG/$cliente/$cliente-$id/preparacion.log
# Creación o Clonado
virt-clone --original Base$so --name $cliente-$id --file $VPS/$cliente-$id-$so.qcow2 2> /dev/null 1>> $OAVPSLOG/$cliente/$cliente-$id/preparacion.log
# Preparacion Maquina
virt-sysprep -d $cliente-$id --root-password password:$contrasena --hostname $cliente-$id --run preparacion.sh 2> /dev/null 1>> $OAVPSLOG/$cliente/$cliente-$id/preparacion.log
# Configuración de Hardware
if [ $vCPU -gt 1 ]
    then
        virsh setvcpus $cliente-$id $vCPU --config --maximum  2> /dev/null 1>> $OAVPSLOG/$cliente/$cliente-$id/preparacion.log #opcion maximun para ignorar el maximo para esta maquina 
fi
if [ $vRAM -gt 1 ]
    then
        virsh setmaxmem $cliente-$id $vRAM\G --config 2> /dev/null 1>> $OAVPSLOG/$cliente/$cliente-$id/preparacion.log #Contra Barra evita anadir la G a la variable
fi
if [ $disco -gt 25 ]
    then
        DiscoAnadido=$(($disco-25)) # 25 GB es el espacio de almacenamiento por defecto
        qemu-img resize $VPS/$cliente-$id-$so.qcow2 +$DiscoAnadido\G 2> /dev/null 1>> $OAVPSLOG/$cliente/$cliente-$id/preparacion.log
fi
virsh start --domain $cliente-$id 2> /dev/null 1>> $OAVPSLOG/$cliente/$cliente-$id/preparacion.log # Arranque 
# Comprobar maquina arrancada
estado=$(virsh list --all --state-shutoff --name | grep "$cliente-$id" | wc -l)
while [ $estado -eq 1 ] 
do
    sleep 2
    $estado=$(virsh list --all --state-shutoff --name | grep "$cliente-$id" | wc -l)
done
# Comprobar arrancado finalizado
esperar=1
while [ $esperar -eq 1 ]
do
    ip=$(virsh domifaddr --domain "$cliente-$id" | grep "192.168" | awk '{print $4}' | sed 's/\/24//g') # IP DE LA MAQUINA
    conexion=$(ping -c1 $ip 2> /dev/null | grep "1 packets transmitted, 1 received, 0% packet loss" |wc -l)
    case $conexion in
        1) if [ $so == 'Centos8' ]
            then
                sshpass -p $contrasena ssh-copy-id -i ~/.ssh/id_rsa.pub -o StrictHostKeyChecking=no root@$ip -p 22 2> /dev/null 1>> $OAVPSLOG/$cliente/$cliente-$id/preparacion.log
            else
                sshpass -p $contrasena ssh-copy-id -i ~/.ssh/id_rsa.pub -o StrictHostKeyChecking=no root@$ip -p 3022 2> /dev/null 1>> $OAVPSLOG/$cliente/$cliente-$id/preparacion.log

        fi
        # Modo auditor
        # echo "$contrasena" > contrasena-$id.txt
        #    exit | sshpass -f contrasena-$id.txt ssh root@$ip -p 3022 #2> /dev/null
        #    sshpass -f contrasena-$id.txt ssh-copy-id root@$ip -p 3022 #2> /dev/null
           #rm contrasena-$id.txt --force
           esperar=0
        ;;
        *) sleep 2
           esperar=1
        ;;
    esac
done
# echo "ANSIBLE: $Plan"
echo "$ip" >> datos.txt 2> /dev/null 1>> $OAVPSLOG/$cliente/$cliente-$id/preparacion.log
echo "VPS Preparado: $(date +"%d-%m-%Y-%R:%S")" 2> /dev/null 1>> $OAVPSLOG/$cliente/$cliente-$id/preparacion.log
echo "" 2> /dev/null 1>> $OAVPSLOG/$cliente/$cliente-$id/preparacion.log
case $so in
    'Debian10') echo $ip >> $SALIDAVPS/salidaVPS.conf # IP para Ansible
    ;;
    'UbuntuServer2004') echo $ip >> $SALIDAVPS/salidaVPS.conf # IP para Ansible
    ;;
    *)
    ;;
esac
# Preparacion del Correo Bienvenida
if [ $notificar -gt 0 ]
    then
        cat $CORREO/bienvenida/plantillaVPS.txt > $CORREO/bienvenida/VPS/Bienvenida-$cliente-$id.txt
        # Personalizacion
        sed -i "s/VPS-CAMBIAR/$so/g" $CORREO/bienvenida/VPS/Bienvenida-$cliente-$id.txt
        sed -i "s/IP-VPS/$ip/g" $CORREO/bienvenida/VPS/Bienvenida-$cliente-$id.txt
        sed -i "s/CONTRASENA-VPS/$contrasena/g" $CORREO/bienvenida/VPS/Bienvenida-$cliente-$id.txt
        # Envio via GMAIL con las credenciales almacenadas en Perfil del usuario
        cat $CORREO/bienvenida/VPS/Bienvenida-$cliente-$id.txt | mail -s "Alta VPS: $so-$id" $email
fi
```

## Script `gruaVPSWindows.sh`

```bash
#!/bin/bash
cliente=$1
id=$2
so=$3
vCPU=$4
vRAM=$5
DiscoAnadido=$6
Plan=$7
notificar=$8
email=$9
contrasena=$(cat /dev/urandom | tr -dc [:upper:][:lower:][:digit:] | head -c32)
# contrasena=Coria21
if [ ! -d $OAVPSLOG/$cliente ]
    then
        mkdir -p $OAVPSLOG/$cliente
        if [ ! -d $OAVPSLOG/$cliente/$cliente-$id ]
            then
                mkdir -p $OAVPSLOG/$cliente/$cliente-$id
        fi
    else
        if [ ! -d $OAVPSLOG/$cliente/$cliente-$id ]
            then
                mkdir -p $OAVPSLOG/$cliente/$cliente-$id
        fi
fi
echo "$(date +"%d-%m-%Y-%R:%S")" 2> /dev/null 1>> $OAVPSLOG/$cliente/$cliente-$id/preparacion.log
echo "$cliente-$id" >> datos.txt 2> /dev/null 1>> $OAVPSLOG/$cliente/$cliente-$id/preparacion.log
# Creación o Clonado
virt-clone --original Base$so --name $cliente-$id --file $VPS/$cliente-$id-$so.qcow2 2> /dev/null 1>> $OAVPSLOG/$cliente/$cliente-$id/preparacion.log
# Configuración de Hardware
if [ $vCPU -gt 1 ]
    then
        virsh setvcpus $cliente-$id $vCPU --config --maximum  1>> $OAVPSLOG/$cliente/$cliente-$id/preparacion.log #opcion maximun para ignorar el maximo para esta maquina 
fi
if [ $vRAM -gt 2 ]
    then
        virsh setmaxmem $cliente-$id $vRAM\G --config 1>> $OAVPSLOG/$cliente/$cliente-$id/preparacion.log #Contra Barra evita anadir la G a la variable
fi
if [ $DiscoAnadido -gt 0 ]
    then
        qemu-img resize $VPS/$cliente-$id-$so.qcow2 +$DiscoAnadido\G 1>> $OAVPSLOG/$cliente/$cliente-$id/preparacion.log
fi
virsh start --domain $cliente-$id 1>> $OAVPSLOG/$cliente/$cliente-$id/preparacion.log # Arranque 
# Comprobar maquina arrancada
estado=$(virsh list --all --state-shutoff --name | grep "$cliente-$id" | wc -l)
while [ $estado -eq 1 ] 
do
    sleep 2
    estado=$(virsh list --all --state-shutoff --name | grep "$cliente-$id" | wc -l)
done
# Comprobar arrancado finalizado
esperar=1
while [ $esperar -eq 1 ]
do
    ip=$(virsh domifaddr --domain "$cliente-$id" | grep "192.168" | awk '{print $4}' | sed 's/\/24//g') # IP DE LA MAQUINA
    if [ -z "$ip" ] 
        then
            echo "$ip"
            sleep 3
            esperar=1
        else
            esperar=0
    fi
done
# echo "ANSIBLE: $Plan"
echo "$ip" >> datos.txt 2> /dev/null 1>> $OAVPSLOG/$cliente/$cliente-$id/preparacion.log
echo "VPS Preparado: $(date +"%d-%m-%Y-%R:%S")" 2> /dev/null 1>> $OAVPSLOG/$cliente/$cliente-$id/preparacion.log
echo "" 2> /dev/null 1>> $OAVPSLOG/$cliente/$cliente-$id/preparacion.log
# Preparacion del Correo Bienvenida
if [ $notificar -gt 0 ]
    then
        cat $CORREO/bienvenida/plantillaVPS.txt > $CORREO/bienvenida/VPS/Bienvenida-$cliente-$id.txt
        # Personalizacion
        sed -i "s/VPS-CAMBIAR/$so/g" $CORREO/bienvenida/VPS/Bienvenida-$cliente-$id.txt
        sed -i '11d' $CORREO/bienvenida/VPS/Bienvenida-$cliente-$id.txt
        sed -i "s/ssh root@IP-VPS -p 3022/ssh Administrador@$ip/g" $CORREO/bienvenida/VPS/Bienvenida-$cliente-$id.txt
        sed -i "s/CONTRASENA-VPS/$contrasena/g" $CORREO/bienvenida/VPS/Bienvenida-$cliente-$id.txt
        cat $CORREO/bienvenida/VPS/Bienvenida-$cliente-$id.txt | mail -s "Alta VPS: $so-$id" $email
fi
```

