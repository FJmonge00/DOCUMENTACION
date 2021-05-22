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
# Preparacion
# Creación o Clonado
virt-clone --original Base-$so --name $cliente-$id --file $VPS/$cliente-$id-$so.qcow2
# Preparacion Maquina
virt-sysprep -d $cliente-$id --root-password password:$contrasena --password hosting:$contrasena2 --hostname $cliente-$id
# Configuración de Hardware
if [ $vCPU -gt 1 ]
    then
        virsh setvcpu $cliente-$id $vCPU --config
fi
if [ $vRAM -gt 2 ]
    then
        virsh setmaxmem $cliente-$id $vRAM\G --config #Contra Barra evita anadir la G a la variable
fi
if [ $DiscoAnadido -gt 0 ]
    then
        qemu-img resize $VPS/$cliente-$id-$so.qcow2 +$DiscoAnadido
fi
echo "ANSIBLE: $Plan"