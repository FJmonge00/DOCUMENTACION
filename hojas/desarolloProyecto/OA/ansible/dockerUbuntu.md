# Plan Desarollo Docker

![foto](../imagenes/docker.png)

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
      become: yes
    - name: Actualizacion del Sistema
      apt: upgrade=dist force_apt_get=yes
      become: yes
  # Instalacion de paquetes necesarios
    - name: Instalacion de pre-requisitos para docker
      apt: name=apt-transport-https state=latest
      become: yes
    - name: Instalacion de pre-requisitos para docker
      apt: name=ca-certificates state=latest
      become: yes
    - name: Instalacion de pre-requisitos para docker
      apt: name=curl state=latest
      become: yes
    - name: Instalacion de pre-requisitos para docker
      apt: name=software-properties-common state=latest
      become: yes
    - name: Instalacion de pre-requisitos para docker
      apt: name=gnupg state=latest
      become: yes
    - name: Instalacion de pre-requisitos para docker
      apt: name=lsb-release state=latest
      become: yes
  # Agregar claves reposotiorios
    - name: Agregar clave GPG oficial de Docker
      apt_key:
        url: https://download.docker.com/linux/ubuntu/gpg
        state: present
  # Repositorios para Ubuntu Server 20.04 (Focal)
    - name: Agregar repositorio oficial de docker
      apt_repository:
        repo: deb https://download.docker.com/linux/ubuntu focal stable # Focal es la version de Ubuntu 20.04
        state: present
  # Instalacion de Docker
    - name: Actualizacion de repositorios e instalacion de docker
      apt: update_cache=yes name=docker-ce state=latest
      become: yes
```