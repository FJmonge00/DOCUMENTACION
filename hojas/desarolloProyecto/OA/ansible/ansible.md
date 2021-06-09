# Ansible

## Ansible y los VPS

Las máquinas base que se clonan y procesan no tienen ningún software adicional al que trae de la propia instalacion estándar. En el hosting se ofrecen "planes" los cuales brinda un VPS con una instalación basica de aquel plan que se eliga.

Los planes del hosting son:

- Entorno LAMP (Apache, MariaDB, PHP 7.3 ó 7.4)
- Entorno LEMP (Nginx, MariaDB, PHP 7.3 ó 7.4)
- Entorno PostgreSQL
- Entorno MariaDB
- Entorno Desarollo Docker (Entorno con Docker instalado y opertivo)

Para configurar estas máquinas con las aplicaciones y servicios que se indiquen utilizamos el orquestador **Ansible**

> También destacar que las máquinas al estar siempre detenidas no se están actualizando las maquinas base constanmente. Con ansible ademas del plan actualizamos las máquinas al crearlas permitiendo así no estar constantemente entrando en las máquinas base para actualizarlas desde ahí, ya que una vez que se encuentran arrancadas no pueden ser clonadas.

Los planes están definidos en una sería de playbooks de Ansible, que son aplicables a máquinas Debian 10 y Ubuntu Server 20.04.

## [Plan PostgreSQL](postgresql.md)
## [Plan MariaDB](mariadb.md)
## [Plan LAMP](lamp.md)
## [Plan LEMP](lemp.md)
## [Plan Desarollo Docker Para Debian 10](dockerDebian.md) 
## [Plan Desarollo Docker Para Ubuntu Server 20.04](dockerUbuntu.md) 
________________________________________
*[Volver al atrás...](./oa.md)*
