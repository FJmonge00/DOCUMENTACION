# PostgreSQL

![mariadb](../imagenes/postgresql.png)

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
  # Apache Instalacion
    - name: Instalacion Y Configuracion de Apache
      apt: name=postgresql state=latest
      become: yes
    - name: Configuracion de Servicios
      service:
        name: postgresql
        state: started
        enabled: yes
      become: yes
```