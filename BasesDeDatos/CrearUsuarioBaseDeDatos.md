# Usuario y Base de Datos
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

## Privilegios

```SQL
GRANT ALL PRIVILEGES ON hosting.* TO 'zeus'@'localhost';
FLUSH PRIVILEGES; -- Cargar los privilegios
GRANT SELECT ON hosting.servicios TO 'thor'@'localhost';
FLUSH PRIVILEGES; -- Cargar los privilegios
```

> Para las repetidas consultas que realizará la oa utilizaremos un usuario con permisos unicamente de lectura sobre la base de datos y en concreto unicamente sobre la base de datos  "hosting "en una determinada tabla que es "servicios". Recomendable esta metodología por seguridad pese a que sola existe una gran tabla en esta base de datos pero si en algun momento quisieramos escalar esto y crear nuevas tablas estaría afectando tambien a estas. CORREGIR]

[Ir a Tablas y Datos](CrearBaseDatosYTablas.md)