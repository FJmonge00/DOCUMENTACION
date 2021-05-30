# Ubuntu Server 20.04 (Focal Fossa) Base
Esta maquina será la que sirva de base para la creacion de servidores virtuales que sean Ubuntu Server
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
--location 'https://releases.ubuntu.com/20.04.2/ubuntu-20.04.2-live-server-amd64.iso'
```

# Version Final

wget -P $BASEVPS https://releases.ubuntu.com/20.04.2/ubuntu-20.04.2-live-server-amd64.iso

```bash
virt-install --name BaseUbuntuServer2004 \
--virt-type kvm \
--hvm \
--os-variant=ubuntu19.04 \
--memory 2048 \
--vcpus 1 \
--network network=default \
--graphics vnc,password=Coria21,listen=0.0.0.0 \
--disk pool=baseVPS,size=25,bus=virtio,format=qcow2 \
--cdrom "$BASEVPS/ubuntu-20.04.2-live-server-amd64.iso" \
--noautoconsole
```
