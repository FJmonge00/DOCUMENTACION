#!/bin/bash
cliente=$1
id=$2
so=$3
vCPU=$4
vRAM=$5
DiscoAnadido=$6
Plan=$7
# contrasena=$(cat /dev/urandom | tr -dc [:upper:][:lower:][:digit:] | head -c32)
contrasena=Coria21
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
    echo "Bucle apagado"
    estado=$(virsh list --all --state-shutoff --name | grep "$cliente-$id" | wc -l)
done
# Comprobar arrancado finalizado
esperar=1
while [ $esperar -eq 1 ]
do
    ip=$(virsh domifaddr --domain "$cliente-$id" | grep "192.168" | awk '{print $4}' | sed 's/\/24//g') # IP DE LA MAQUINA
    echo "$ip"
    if [ -z "$ip" ] 
        then
            echo "$ip"
            sleep 10
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
        sed -i "s/IP-VPS/$ip/g" $CORREO/bienvenida/VPS/Bienvenida-$cliente-$id.txt
        sed -i "s/CONTRASENA-VPS/$contrasena/g" $CORREO/bienvenida/VPS/Bienvenida-$cliente-$id.txt
        cat $CORREO/bienvenida/VPS/Bienvenida-$cliente-$id.txt | mail -s "Alta VPS: $so-$id" $email
fi