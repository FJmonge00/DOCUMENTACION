# Máquinas Base

Creamos unas maquinas virtuales base en la que instalamos el Sistema Opertivo y configuración estandar, una vez terminada estas maáquinas son detenidas.

Estás Máquinas serán clonadas y tratadas para generar un VPS totalmente Opertivo

## Creación de Máquinas Base

> Los cambios que realizamos en estas máquinas afectarán a todas los VPS que se generen por lo que es importante instalar y configurar estas maquinas correctamente y sin ninguna apliación exepto las instaltas por defecto ya que deben ser escalables para los distintos planes que ofrece el hosting.

## Debian 10

```bash
virt-install --name Debian10_ \
--virt-type kvm \
--hvm \
--accelerate \
--os-variant=debian10 \
--memory 2048 \
--vcpus 1 \
--network network=default \
--graphics vnc,password=Coria21,listen=0.0.0.0 \
--disk pool=baseVPS,size=25,bus=virtio,format=qcow2 \
--noautoconsole \
--location 'http://ftp.us.debian.org/debian/dists/stable/main/installer-amd64/'
```

![foto](./imagenes/crearDebian.jpg)
![foto](./imagenes/instalacionBaseDebian.png)
![foto](./imagenes/DebianBase.jpg)

## Ubuntu Server 20.04

### Obtener Imagen ISO Oficial:

```bash
wget -P $BASEVPS https://releases.ubuntu.com/20.04.2/ubuntu-20.04.2-live-server-amd64.iso
```

### Comprobar integridad de la Imagen hash

```bash

```

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

![foto](./imagenes/crearDebian.jpg)
![foto](./imagenes/instalacionBaseDebian.png)
![foto](./imagenes/DebianBase.jpg)