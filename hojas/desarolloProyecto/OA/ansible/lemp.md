# Entorno LEMP

![lamp](../imagenes/lemp.jpg)

Eligiendo este plan ansible instalaremos: 

- Nginx
- MariaDB 
- PHP

```yml
---
- hosts: salidaVPS
  # remote_user: root
  vars:
    ansible_ssh_user: 'root'
    ansible_port: '3022'
  tasks:
  # Apt update y uprade
    - name: Actualizacion de VPS
      apt: update_cache=yes state=latest force_apt_get=yes cache_valid_time=3600 # Si tiene mas de 1 hora de antiguedad
    - name: Actualizacion del Sistema
      apt: upgrade=dist force_apt_get=yes
  # Nginx Instalacion
    - name: Instalacion Y Configuracion de nginx
      apt: name=nginx state=latest
      become: yes
    - name: Configuracion de Servicios
      service:
        name: nginx
        state: started
        enabled: yes
      become: yes
  # Instalacion MariaDB
    - name: Instalacion Y Configuracion de mariadb
      apt: name=mariadb-server state=latest
      become: yes
    - name: Configuracion de Servicios
      service:
        name: mariadb
        state: started
        enabled: yes
      become: yes
  # Instalacion PHP
    - name: Instalacion Y Configuracion de PHP
      apt: name=php-fpm state=latest
      become: yes
    - name: Instalacion Y Configuracion de PHP
      apt: name=php-mysql state=latest
      become: yes
```