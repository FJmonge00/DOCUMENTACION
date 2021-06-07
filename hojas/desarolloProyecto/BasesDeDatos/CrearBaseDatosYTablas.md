# Definición de Tablas y Datos.📖

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

![imagen](./imagenes/Tablas.jpg)

![imagen](./imagenes/TablaVps.jpg)

## Modificacion del valor de Auto-incremento

```sql
ALTER TABLE `hosting`.`servicios` AUTO_INCREMENT=1000;
ALTER TABLE `hosting`.`vps` AUTO_INCREMENT=9500;
```

![imagen](./imagenes/Tablas2.jpg)

![imagen](./imagenes/autoincrementoVps.jpg)

## Adaptación de las tablas a la notificación mail

```sql
ALTER TABLE `servicios` ADD `notificar` BOOLEAN NOT NULL AFTER `cliente`, ADD `email` VARCHAR(80) NULL AFTER `notificar`;
```

> Con _AFTER_ consegimos que las nuevas columnas se añadan en la ubicación que requiero para que no afecte a los distintos programas, scripts o servicios que conforman la **OA**. _Hay que extaerse y estudiar cada cambio que se haga en entidades como esta ya que el mas minimo cambio puede afectar al desarollo natural de programas y servicios que depende de esta. SOBRE TODO SI ESTE SE ENCUENTRA EN PRODUCCIÓN COMO ES EL CASO_

![imagen](./imagenes/cambiosBBDD.jpg)

```sql
ALTER TABLE `vps` ADD `notificar` BOOLEAN NOT NULL AFTER `disco`, ADD `email` VARCHAR(80) NULL AFTER `notificar`;
```

![imagen](./imagenes/cambiosBBDD2.jpg)


## Los datos

Estas tablas contendrán los datos de aquellos servicios y VPS que despleguemos en el hosting, cuando vayamos a desplegar un servicio o VPS a través del interfaz web de la OA, este se registrara en la base de datos, y estos datos son los que se usarán para el despliegue del servicio con Kubernetes o de maquinas virtuales en KVM-Qemu. 

Es importante tener registrados los datos de los servicios que tengamos de los clientes, en el caso de Kubernetes,siendo una tecnología de microservicios genera una gran cantidad de entidades que después tendremos que encontrar e identificar y puede dar lugar a tener que buscar entre millares de servicios. Por ello mantendremos registrado estos en la base de datos.

Para insertar estos datos haremos uso de una interfaz web PHP.

Ver Formularios

________________________________________
*[Volver al atrás...](./README.md)*