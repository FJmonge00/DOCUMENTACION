# Entorno LAMP

![mariadb](../imagenes/MariaDB.jpg)

```yml
---
- hosts: salidaVPS
  # remote_user: root
  vars:
    ansible_ssh_user: 'root'
    ansible_port: '3022'
  tasks:
  # Apt update y uprade
    - name: Actualizacion de repositorios
      apt: update_cache=yes state=latest force_apt_get=yes cache_valid_time=3600 # Si tiene mas de 1 hora de antiguedad
    - name: Actualizacion del Sistema
      apt: upgrade=dist force_apt_get=yes
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
```
