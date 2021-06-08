<!-- # virt-install --name prueba1 \
#     --virt-type kvm --hvm --os-variant=debian10 \
#     --ram 2048 -vcpus 2 --network network=default \
#     --graphics vnc,password=Coria21,listen=0.0.0.0 \
#     --disk pool=default,size=20,bus=virtio,format=qcow2 \
#     --cdrom /var/lib/libvirt/images/debian-10.1.0-amd64-xfce-CD-1.iso \
#     --noautoconsole \
#     --boot cdrom,hd -->

# Version clase

```bash
virt-install --connect qemu:///system --name ServerCorreo --memory 4096 --disk path=/var/lib/libvirt/images/ServidorCorreo.qcow2,size=25 --vcpus=1 -c /var/lib/libvirt/images/debian-10.1.0-amd64-xfce-CD-1.iso --vnc --os-type linux --network bridge=virbr0 --noautoconsole --hvm --keymap es
```
# Version Simple

```bash
virt-install --name vm-test \
--virt-type kvm --hvm --os-variant=debian10 \
--memory 2048 --vcpus 2 --network network=default \
--graphics vnc,password=remotevnc,listen=0.0.0.0 \
--disk pool=default,size=20,bus=virtio,format=qcow2 \
--cdrom /var/lib/libvirt/images/debian-10.1.0-amd64-xfce-CD-1.iso  \
--noautoconsole \
--boot cdrom,hd
```

# Version base Cloud

```bash
nombreMaquina=PruebaBaseCloud
virt-install \
--name $nombreMaquina \
--disk pool=default,size=20,bus=virtio,format=qcow2 \
--vcpus 1 \
--ram 1024 \
--os-type linux \
--os-variant debian10 \
--network bridge=br0 \
--graphics vnc,password=remotevnc,listen=0.0.0.0 \
--noautoconsole \
--location 'http://ftp.us.debian.org/debian/dists/stable/main/installer-amd64/'
```

# Clonar maquina limpia

```bash
virt-clone --original debian-machine-image --name vm-debian-01 --file vm-debian-01.qcow2
```

# Limpieza de maquina

```bash
virt-sysprep -d ServerCorreo
```

# Usuarios de la mqaquina virtual ES NECESARIO INSTALAR Y ARRANCAR EL Qemu-guest-agent

```bash
virsh set-user-password NuevoCliente --user usuario --password 1234
```

# Memoria

```bash
virsh setmaxmem ServerCorreo 4G --config
```
# CPU

```bash
virsh setvcpu NuevoCliente 4 --config
```

# ENLACES DE INTERES
https://onthedock.github.io/post/200627-creacion-de-vm-en-kvm-con-virsh/
# Borrado para preparar la clonacion
https://es.linux-console.net/?p=2446
# Principalmente el location del Cloud
https://www.elarraydejota.com/plantillas-virt-install-para-crear-rapidamente-maquinas-virtuales-kvm/
# ES NECESARIO INSTALAR PARA LAS UTILIDADES
https://command-not-found.com/virt-sysprep
# muchos COMANDOS CLONACIONES
https://onthedock.github.io/post/190213-como-clonar-vms-y-usar-sysprep-en-kvm/
# pOSIBLE AYUDA PARA EL QUEMU-GUEST-agent
https://pve.proxmox.com/wiki/Qemu-guest-agent
# cambio de memoria, cpu, usuarios etc
https://qastack.mx/server/403561/change-amount-of-ram-and-cpu-cores-in-kvm