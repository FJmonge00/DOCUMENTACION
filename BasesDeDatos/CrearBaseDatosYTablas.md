# Tablas y datos

## Tablas

<!-- ```sql
CREATE TABLE `hosting`.`servicios` ( `id` INT NOT NULL AUTO_INCREMENT , `app` INT NOT NULL , `cliente` INT NOT NULL , `fecha` DATE NOT NULL DEFAULT CURRENT_TIMESTAMP , PRIMARY KEY (`id`)) ENGINE = InnoDB;
``` -->

### Tabla de los servicios

```sql
CREATE TABLE `hosting`.`servicios` ( `id` INT NOT NULL AUTO_INCREMENT , `app` VARCHAR(40) NOT NULL , `version` VARCHAR(80) NOT NULL , `cliente` VARCHAR(40) NOT NULL , `fecha` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP , PRIMARY KEY (`id`)) ENGINE = InnoDB;
```

### Tabla de MV de VPS

```sql
CREATE TABLE `hosting`.`vps` ( `id` INT NOT NULL AUTO_INCREMENT , `so` VARCHAR(40) NOT NULL , `plan` VARCHAR(80) NOT NULL , `cliente` VARCHAR(40) NOT NULL , `vcpu` INT NOT NULL,`vram` INT NOT NULL,`disco` INT NOT NULL, `fechapreparada` DATETIME,`fechasolicitud` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP , PRIMARY KEY (`id`)) ENGINE = InnoDB;
```
[¿InnoDB ó MyISAM?](https://www.arsys.es/blog/programacion/bases-de-datos/myisam-o-innodb-elige-tu-motor-de-almacenamiento-mysql/)

![imagen](../BasesDeDatos/imagenes/Tablas.jpg)
![imagen](../BasesDeDatos/imagenes/TablaVps.jpg)

### Modificacion del valor de Auto-incremento

```sql
ALTER TABLE `hosting`.`servicios` AUTO_INCREMENT=1000;
ALTER TABLE `hosting`.`vps` AUTO_INCREMENT=9500;
```

![imagen](../BasesDeDatos/imagenes/Tablas2.jpg)
![imagen](../BasesDeDatos/imagenes/autoincrementoVps.jpg)

## Los datos

Estas tablas contendrán los datos de aquellos servicios y VPS que despleguemos en el hosting, cuando vayamos a desplegar un servicio o VPS a través del interfaz web de la OA, este se registrara en la base de datos, y estos datos son los que se usarán para el despliegue del servicio con Kubernetes o de maquinas virtuales en KVM-Qemu. 

Es importante tener registrados los datos de los servicios que tengamos de los clientes en el caso de Kubernetes, ya que las tecnologías de microservicios genera una gran cantidad de entidades que después tendremos que encontrar e identificar y puede dar lugar a tener que buscar entre millares de servicios. Por ello mantendremos registrado estos en la base de datos.

Para insertar estos datos haremos uso formularios web con PHP.

Ver Formularios