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
wget -P $BASEVPS https://ftp.cica.es/CentOS/8.3.2011/isos/x86_64/CentOS-8.3.2011-x86_64-minimal.iso

virt-install --name BaseCentos8 \
--virt-type kvm \
--hvm \
--os-variant=Centos7.0 \
--memory 8096 \
--vcpus 4 \
--network network=default \
--graphics vnc,password=Coria21,listen=0.0.0.0 \
--disk pool=baseVPS,size=25,bus=virtio,format=qcow2 \
--cdrom "$BASEVPS/CentOS-8.3.2011-x86_64-minimal.iso" \
--noautoconsole
```