# Panel Administraci贸n Web.馃摉 

## Pagina Principal

La web principal es puramente HTML y CSS, desde aqu铆 podremos acceder a los distintos paneles de web de administracion de la OA y a phpMyAdmin

![foto](./imagenes/webPrincipal.jpg)

```html
<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8">
        <title>Panel Administraci贸n</title>
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <link rel="stylesheet" href="https://www.w3schools.com/w3css/4/w3.css">
    </head>
<body>
    <div class="w3-container w3-blue">
    <h1>Panel de Administraci贸n OA</h1> 
    <p>Cuidado con lo que haces!</p> 
    </div>

    <div class="w3-row-padding">
    <div class="w3-third">
        <h2>Panel Administraci贸n VPS</h2>
        <a href="http://192.168.0.20/hosting/oaVPS/panelVPS.php">Panel Administraci贸n VPS</a>
        <p>Aqui puedes levantar las distintas Maquinas virtuales o VPS,
            cada 3 minutos se aplicar谩n los cambios.</p>
    </div>

    <div class="w3-third">
        <h2>Panel Administraci贸n Servicios</h2>
        <a href="http://192.168.0.20/hosting/oa/panelServicios.php">Panel Administraci贸n Servicios</a> 
        <p>Aqui puedes levantar los distintos Servicios disponibles,
            cada 3 minutos se aplicar谩n los cambios.</p>
        </div>
        
        <div class="w3-third">
            <h2>Administraci贸n de la Base de datos</h2>
            <a href="http://192.168.0.20/phpMyAdmin/">Administraci贸n de la Base de datos</a> 
        <p>Desde aqu铆 podras acceder a la base de datos donde estan los Servicios y VPS </p>
    </div>
    </div>
</body>
</html>
```

### Panel de Administraci贸n de VPS

La web de Control VPS esta hecha con; HTML,CSS y PHP. Desde el Panel de Control de VPS podremos:

-  Ver los VPS que se encuentran actualmente activos y registrados en la Base de Datos.

![foto](./imagenes/todosVPS.jpg)
![foto](./imagenes/todosVPS2.jpg)

-  Buscar por Identificador un VPS que se encuentre activo y registrado en la Base de Datos.

![foto](./imagenes/busquedaIDVPS.jpg)
![foto](./imagenes/busquedaIDVPS2.jpg)

-  Ver el Identificador del ultimo VPS que se encuentra registrado en la Base de Datos.

![foto](./imagenes/ultimoVPS.jpg)

-  Lanzar una nueva Maquina Virtual o VPS registrandola en la Base de Datos.
    -  Podremos configurar:
        - El nombre del cliente.
        - Numero de Procesadores o vCPUs. (min 1, max 8)
        - Tama帽o de la RAM o vRAM. (min 1, max 24)
        - Tama帽o de disco Nvme. (min 25, max 100)
        - Sistema Opertivo.
            - Debian 10
            - Ubuntu Server 20.04
            - Centos 8
            - Windows Server 2019
        - Plan del Hosting.
            - Entorno LAMP (Apache, MariaDB, PHP 7.3 贸 7.4)
            - Entorno LEMP (Nginx, MariaDB, PHP 7.3 贸 7.4)
            - Entorno PostgreSQL 
            - Entorno MariaDB 
            - Entorno Desarollo Docker (Entorno con Docker instalado y opertivo)
        - Acci贸n de Notificar via email al cliente (Envio de Datos de Acceso, credenciales, mensaje de bienvenida, etc).
        - La direccion de correo a la que queremos notificarlo.

![GIF](./imagenes/lanzarVPS.gif)

### 鈫撯啌鈫撯啌鈫撯啌鈫撯啌鈫撯啌鈫撯啌鈫撯啌鈫撯啌鈫撯啌鈫撯啌鈫撯啌鈫撯啌鈫?
### [ 鈫? CLIC AQU脥 PARA VER WEBS PHP del panel de VPS 鈫? ](./hosting/oaVPS)
### 鈫戔啈鈫戔啈鈫戔啈鈫戔啈鈫戔啈鈫戔啈鈫戔啈鈫戔啈鈫戔啈鈫戔啈鈫戔啈鈫戔啈鈫?

Una vez indicada la condiguracion de la maquina y lanzada la OA realizar谩 la consulta SQL y la levantar谩 en KVM-QEMU.

_Ver en el punto de la OA_

### Panel de Administraci贸n de Servicios

La web de Control VPS esta hecha con; HTML,CSS y PHP. Desde el Panel de Control de Servicios podremos:

-  Ver los Servicios que se encuentran actualmente activos y registrados en la Base de Datos.

![foto](./imagenes/todosServicios.jpg)
![foto](./imagenes/todosServicios2.jpg)

-  Buscar por Identificador un Servicio que se encuentre activo y registrado en la Base de Datos.

![foto](./imagenes/busquedaID.jpg)
![foto](./imagenes/busquedaID2.jpg)

-  Ver el Identificador del ultimo Servicios que se encuentra registrado en la Base de Datos.

![foto](./imagenes/ultimoServicio.jpg)

-  Lanzar un nuevo Servicios registrandolo en la Base de Datos.
    -  Podremos configurar:
        - El nombre del cliente.
        - App o Servicio.
            - WordPress
            - Joomla
            - PrestaShop
            - MediaWiki _(No disponible automatico)_
            - Drupal
        - Versi贸n de Servicio.
            - WordPress 4.8
            - Joomla 3.9.25
            - PrestaShop 1.7.7.2
            - MediaWiki 1.35.1
            - Druapal 9.1.6
        - Acci贸n de Notificar via email al cliente (Envio de Datos de Acceso, credenciales, mensaje de bienvenida, etc).
        - La direccion de correo a la que queremos notificarlo.

![GIF](./imagenes/lanzar.gif)

### 鈫撯啌鈫撯啌鈫撯啌鈫撯啌鈫撯啌鈫撯啌鈫撯啌鈫撯啌鈫撯啌鈫撯啌鈫撯啌鈫撯啌鈫?
### [ 鈫? CLIC AQU脥 PARA VER WEBS PHP del panel de Servicios 鈫? ](./hosting/oa)
### 鈫戔啈鈫戔啈鈫戔啈鈫戔啈鈫戔啈鈫戔啈鈫戔啈鈫戔啈鈫戔啈鈫戔啈鈫戔啈鈫戔啈鈫?

Una vez indicado el Servicio y su versi贸n la OA realizar谩 la consulta SQL y levantar谩 el contenedor de Docker en el Cl煤ster con Kubernetes.

________________________________________
*[Volver al atr谩s...](../README.md)*