# Crear Usuarios y Bases De Datos 📖
**Por seguridad** no utilizaré usuario root sino un usuario con todos los privilegios sobre la base de datos en la que deba trabajar (Hosting).

## Crear usuario

```SQL
CREATE USER 'zeus'@'localhost' IDENTIFIED BY 'Coria21';
CREATE USER 'thor'@'localhost' IDENTIFIED BY 'Coria21';
```

## Crear Base de Datos

```sql
CREATE DATABASE hosting;
```

## Privilegios de usuarios

```SQL
GRANT ALL PRIVILEGES ON hosting.* TO 'zeus'@'localhost';
FLUSH PRIVILEGES; -- Cargar los privilegios
GRANT SELECT ON hosting.servicios TO 'thor'@'localhost';
GRANT SELECT ON hosting.vps TO 'thor'@'localhost';
FLUSH PRIVILEGES; -- Cargar los privilegios
```

> Para las repetidas consultas que realizará la oa utilizaremos un usuario con permisos únicamente de lectura sobre la base de datos y en concreto únicamente sobre la base de datos "hosting" y en unas determinadas tablas que son; "servicios" y "vps". Es Recomendable esta metodología por seguridad, pese a que sola existe 2 grandes tablas en esta base de datos, si en algún momento quisiéramos escalar esto y crear nuevas tablas nuevas estaría afectando también a estas.

________________________________________
*[Volver al atrás...](./README.md)*