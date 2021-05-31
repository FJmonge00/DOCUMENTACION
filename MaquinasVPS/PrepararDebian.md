# Debian 10 (Buster) Base
Esta maquina será la que sirva de base para la creacion de servidores virtuales que sean Debian 10
## Implementación e Instalación
# Version Simple

```bash
virt-install --name vm-test \
--virt-type kvm --hvm --os-variant=debian10 \
--memory 2048 --vcpus 2 --network network=default \
--graphics vnc,password=contrasena,listen=0.0.0.0 \
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
--graphics vnc,password=contrasena,listen=0.0.0.0 \
--noautoconsole \
--location 'http://ftp.us.debian.org/debian/dists/stable/main/installer-amd64/'
```

# Version Final

```bash
virt-install --name Debian10 \
--virt-type kvm \
--hvm \
--accelerate \
--os-variant=centos7.0 \
--memory 2048 \
--vcpus 1 \
--network network=default \
--graphics vnc,password=Coria21,listen=0.0.0.0 \
--disk pool=baseVPS,size=25,bus=virtio,format=qcow2 \
--noautoconsole \
--location 'http://ftp.us.debian.org/debian/dists/stable/main/installer-amd64/'
```