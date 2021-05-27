#!/bin/bash
id=9512
cliente=inerco
so=Debian10
vCPU=2
vRAM=4
DiscoAnadido=10
Plan="Instalar LAMP"
contrasena=$(cat /dev/urandom | tr -dc [:upper:][:lower:][:digit:] | head -c32)
# contrasena=Coria21
echo "$cliente-$id" >> datos.txt
echo "$contrasena" >> datos.txt
# Preparacion
# Creación o Clonado
virt-clone --original Base$so --name $cliente-$id --file $VPS/$cliente-$id-$so.qcow2 #Contra Barra evita anadir Base a la variable
# Preparacion Maquina
# virt-sysprep -d $cliente-$id --root-password password:$contrasena --hostname $cliente-$id
virt-sysprep -d $cliente-$id --root-password password:$contrasena --hostname $cliente-$id --run preparacion.sh
# Configuración de Hardware
if [ $vCPU -gt 1 ]
    then
        virsh setvcpus $cliente-$id $vCPU --config --maximum #opcion maximun para ignorar el maximo para esta maquina
fi
if [ $vRAM -gt 2 ]
    then
        virsh setmaxmem $cliente-$id $vRAM\G --config #Contra Barra evita anadir la G a la variable
fi
if [ $DiscoAnadido -gt 0 ]
    then
        qemu-img resize $VPS/$cliente-$id-$so.qcow2 +$DiscoAnadido\G
fi
virsh start --domain $cliente-$id # Arranque
# sshpass -f password.txt ssh-copy-id root@192.168.122.157 -p 3022
esperar=1
while [ $esperar -eq 1 ] 
do
    $conexion=$(ping -c1 $ip | grep "1 packets transmitted, 1 received, 0% packet loss" |wc -l)
    case $conexion in
        1) sshpass -f $contrasena ssh-copy-id root@$ip -p 3022
           esperar=0
        ;;
        *) sleep 2
           esperar=1
        ;;
    esac
done
echo "ANSIBLE: $Plan"
arp -n | grep $(virsh dumpxml $cliente-$id | grep mac\ address | cut -d \' -f 2 ) | cut -d \  -f 1 >> datos.txt
echo ""  >> datos.txt