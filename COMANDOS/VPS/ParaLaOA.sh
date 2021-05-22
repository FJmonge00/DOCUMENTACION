#!/bin/bash
id=9500
cliente=inerco
so=Debian10
vCPU=2
vRAM=4
DiscoAnadido=10
Plan="Instalar LAMP"
contrasena=$(cat /dev/urandom | tr -dc [:upper:][:lower:][:digit:] | head -c32)
contrasena2=$(cat /dev/urandom | tr -dc [:upper:][:lower:][:digit:] | head -c32)
echo "$contrasena"
echo "$contrasena2"
# Preparacion
# Creación o Clonado
virt-clone --original Base$so --name $cliente-$id --file $VPS/$cliente-$id-$so.qcow2 #Contra Barra evita anadir Base a la variable
# Preparacion Maquina
virt-sysprep -d $cliente-$id --root-password password:$contrasena --hostname $cliente-$id
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
virsh start --domain $cliente-$id
echo "ANSIBLE: $Plan"