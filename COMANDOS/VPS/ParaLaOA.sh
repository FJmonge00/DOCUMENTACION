#!/bin/bash
cliente=$1
id=$2
# so=Debian10
so=$3
# vCPU=2
vCPU=$4
# vRAM=4
vRAM=$5
# DiscoAnadido=10
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
# Preparacion Maquina
virt-sysprep -d $cliente-$id --root-password password:$contrasena --hostname $cliente-$id --run preparacion.sh 2> /dev/null 1>> $OAVPSLOG/$cliente/$cliente-$id/preparacion.log
# Configuración de Hardware
if [ $vCPU -gt 1 ]
    then
        virsh setvcpus $cliente-$id $vCPU --config --maximum  2> /dev/null 1>> $OAVPSLOG/$cliente/$cliente-$id/preparacion.log #opcion maximun para ignorar el maximo para esta maquina 
fi
if [ $vRAM -gt 2 ]
    then
        virsh setmaxmem $cliente-$id $vRAM\G --config 2> /dev/null 1>> $OAVPSLOG/$cliente/$cliente-$id/preparacion.log #Contra Barra evita anadir la G a la variable
fi
if [ $DiscoAnadido -gt 0 ]
    then
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
        1) sshpass -p $contrasena ssh-copy-id -i ~/.ssh/id_rsa.pub -o StrictHostKeyChecking=no root@$ip -p 3022 2> /dev/null 1>> $OAVPSLOG/$cliente/$cliente-$id/preparacion.log
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