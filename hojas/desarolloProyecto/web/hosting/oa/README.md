# En la parte superior se encuentan los ficheros PHP utilizados para interacturar via PHP con la OA y la Base de Datos

# Webs que conforman el Panel de Administración de Servicios

## Pagina Principal del Panel de Administración de Servicios.

En esta web es donde interactua el Administrador con la OA y la base de datos. 

En esta web podremos:
- Acceder a los datos a través del form que tiene como `action` → `verTodosServicios.php`.
- Buscar en la base de datos a través del form que tiene como `action` → `buscarPorID.php`.
- Insertar y lanzar un servicio a través del form que tiene como `action` → `insertRegistrosOA.php`.

```php
<html>
	<head>
		<title>Admin OA Servicios</title>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <meta charset="utf-8"/>
        <link rel="stylesheet" href="style.css">
	</head>
	<body>
		<div class="cabecera">
			<h1>Panel Administración Servicios</h1>
		</div>
		<div class="Mostrar"> 
			<h2> Todos los Servicios</h2>
			<form action="verTodosServicios.php" method="post">
				<input type ="submit" value="Mostrar" />
			</form>
		</div>
		<div class="Busqueda">
			<h2> Búsqueda de Servicio </h2>
			<form action= "buscarPorID.php" method="post">
				<b>id:</b><input type="text" name="identificador" size="4" maxlength="4" placeholder="Buscar Servicio..."/> 
				<input type ="submit" value="Buscar" />
				<input type="Reset" value="Limpiar">
			</form>
		</div>
		<br>
		<br>
		<!-- <h1>________________________________________________________________________________________________</h1> -->
		<div class=Nuevo>
			<h2 style="text-align: center"> Ultimo Servicio lanzado </h2>
			<table style="margin: 5px;margin-left: 50%;text-align: center;padding: 3px;" border=2>
				<tr>
					<td>Id</td>
				</tr>
				<?php
				include("ultimoServicio.php");
				foreach($res as $registros){ ?>
				<tr>
					<td><?php echo $registros["id"]?></td>
				</tr>
				<?php }?>
			</table>
			</div>
		<br>
		<br>
		<div class=Nuevo>
			<h2>Nuevo Servicio</h2>
			<form action="insertRegistrosOA.php" method="post">
				<b>Cliente:</b>
				<input type="text" name="cliente" size="20" maxlength="80" required placeholder="Nombre Cliente..."> 
				<br>
				<br>
				<b> App:</b>
				<br>
				<select name="app">
					<!-- Opciones de la lista -->
					<option value="joomla">Joomla</option>
					<option value="wordpress">WordPress</option>
					<option value="prestashop">PrestaShop</option>
					<option value="mediawiki">MediaWiki</option>
					<option value="drupal">Drupal</option>
				</select>
				<br>
				<br>
				<b> Versión de App:</b>
				<br>
				<select name="version">
					<!-- Opciones de la lista -->
					<option value="joomla:3.9.25-apache">Joomla 3.9.25</option>
					<option value="wordpress:4.8-apache">WordPress 4.8</option>
					<option value="prestashop/prestashop:1.7.7.2-apache">PrestaShop 1.7.7.2</option>
					<option value="mediawiki:1.35.1">MediaWiki 1.35.1</option>
					<option value="drupal:9.1.6-php8.0-apache-buster">Druapal 9.1.6</option>
				</select>
				<br>
				<br>
				<b> Noticar al cliente:</b>
				<br>
				<input type="radio" id="si" name="notificar" checked value="1">
				<label for="si">Si</label><br>
				<input type="radio" id="no" name="notificar" value="0">
				<label for="no">No</label><br>
				<br>
				<br>
				<input type="email" name="email" size="20" maxlength="80" placeholder="cliente@mail.com ..."> 
				<br>
				<br>
				<input type="submit" value="Lanzar Servicios">
				<br>
				<br>
				<input type="Reset" value="Limpiar">
			</form>
		</div>
	</body>
</html>
```

## CSS del Panel de Administración de Servicios

```css
.Nuevo, .Busqueda, .Mostrar {
    background: rgb(23,182,184);
background: linear-gradient(0deg, rgba(23,182,184,1) 0%, rgba(233,162,9,1) 100%);
    box-shadow: 10px 10px grey;
    /* display: flex;
    flex-direction: row; */
}
input {
    width: 100%;
  }
  input[type=text] {
    width: 100%;
    padding: 12px 20px;
    margin: 8px 0;
    box-sizing: border-box;
  }
  input[type=text]:focus {
    background-color: lightblue;
  }
  select {
    width: 100%;
    padding: 16px 20px;
    border: none;
    border-radius: 4px;
    background-color: #f1f1f1;
  }
  input[type=button], input[type=submit], input[type=reset] {
    padding: 16px 32px;
    margin: 4px 2px;
    cursor: pointer;
  }
html,body {
    background-color: 250, 235, 215;
}
#si,#no {
  width: auto;
}
```

## PHP para ver Todos los Servicios actuales y registrados en la Base de datos (`verTodosServicios.php`)

```php
<html>
	<head>
		<meta charset="UTF-8">
		<title>Busqueda Por id</title>
		<meta name="viewport" content="width=device-width, initial-scale=1">
		<style>
			body {
				background: rgb(23,182,184);
				background: linear-gradient(0deg, rgba(23,182,184,1) 0%, rgba(233,162,9,1) 100%);
				}
			table {
			width: 100%;
			}
			tr {
				border: 2px solid black; 
				background: white;
			}
			h2 {
					text-align: center
			}
			th, td {
			text-align: center;
			padding: 10px
			}
			tr:nth-child(even) {background-color: #AED6F1;}
		</style>
	</head>
	<body>
		<h2> Servicios Actuales </h2>
		<table>
			<tr>
				<td>Identificador</td>
				<td>Aplicacion</td>
				<td>Version</td>
				<td>Cliente</td>
				<td>Fecha</td>
			</tr>
			<?php
			include("ejecutaSelect.php");
			//En $res está guardada el resultado de ejecutaSelect.php
			foreach($res as $registros){ ?>
			<tr>
				<td><?php echo $registros['id']?></td>
				<td><?php echo $registros['app']?></td>
				<td><?php echo $registros['version']?></td>
				<td><?php echo $registros['cliente']?></td>
				<td><?php echo $registros['fecha']?></td>
			</tr>
			<?php }?>
		</table>
	</body>
</html>
```

## PHP que utilizará `verTodosServicios.php` para obtener los registros _(Depende de conexion.php)_.

Realmente esta es la parte del PHP que consulta los datos a MariaDB, `verTodosServicios.php` únicamente muestra lo que obtiene este PHP con la `mysqli_query`:

```php
<?php
include("conexion.php"); # Conexion a la base de datos
//Devuelve todos los registros de una tabla
function consulta($conn,$query){
	$resultado = mysqli_query($conn,$query);
	return $resultado;
}
$res = consulta($conn,"SELECT * FROM servicios");
mysqli_close($conn); //cierra la conexion con MariaDB
?>
```

## PHP para buscar por el ID del Servicio _(Depende del conexion.php que es el Punto siguiente)_
```php
<html>
	<head>
		<meta charset="UTF-8">
		<title>Busqueda Por id</title>
		<meta name="viewport" content="width=device-width, initial-scale=1">
		<style>
			body {
				background: rgb(23,182,184);
				background: linear-gradient(0deg, rgba(23,182,184,1) 0%, rgba(233,162,9,1) 100%);
				}
			table {
			/* border-collapse: collapse; */
			/* border: 2px solid black; */
			width: 100%;
			}
			tr {
				border: 2px solid black; 
				background: white;
			}
			h2 {
				text-align: center
			}
			th, td {
			text-align: center;
			padding: 10px
			}
			tr:nth-child(even) {background-color: #AED6F1;}
		</style>
	</head>
	<body>
		<h2> Servicio </h2>
		<table>
			<tr>
				<td>Id</td>
				<td>Aplicacion</td>
				<td>Cliente</td>
				<td>Fecha</td>
			</tr>
			<?php
			include("ejecutaSelectid.php");
			//Variable $res está guardado el resultado de ejecutaSelect.php
			foreach($res as $registros){ ?>
			<tr>
				<td><?php echo $registros['id']?></td>
				<td><?php echo $registros['app']?></td>
				<td><?php echo $registros['cliente']?></td>
				<td><?php echo $registros['fecha']?></td>
			</tr>
			<?php }?>
		</table>
	</body>
</html>
```

## PHP que utilizará `buscarPorID.php` para obtener el registro _(Depende del conexion.php)_.

Realmente esta es la parte del PHP que consulta los datos a MariaDB, consulta el registro de `ID` con valor `X`, `buscarPorID.php` únicamente muestra lo que obtiene este PHP con la `mysqli_query`. (El id que consultará es el indicado en el form)

```php
<?php
//Recogida de variables
$identificador =$_POST["identificador"]; # Formulario
include("conexion.php"); # Conexion Base de datos
function consulta($conn,$query){
	$resultado = mysqli_query($conn,$query);
	return $resultado;
}
$res = consulta($conn,"SELECT * FROM servicios WHERE id='$identificador'");
mysqli_close($conn); //cierra la conexion
?>
```

## PHP Para conectarsese a MariaDB y seleccionar la Base de Datos

Conecta con MariaDB que se encuentra en el mismo servidor donde se ejecuta este PHP `127.0.0.1` ó `localhost`, mediante el usuario creado anteriomente llamado `zeus` y contraseña en este caso `Coria21`.

Si la conexion se realiza correctamente al servidor de datos en 127.0.0.1 con `mysqli_select_db` indicamos que utilice la Base de datos `hosting`

_La informacion de los usuarios y Bases de datos esta en el primer punto en: → [`Bases de datos y configuración`](../../../BasesDeDatos/README.md). ←_

```php
<?php
function conexion(){
   if (!($conn=mysqli_connect("localhost","zeus","Coria21")))
   {
      echo "Error al conectar con MariaDB.";
      exit();
   }
   if (!mysqli_select_db($conn,"hosting"))
   {
      echo "Error al conectarse a la base de datos hosting.";
      exit();
   }
   return $conn;
}
$conn=conexion();
?>
```

## PHP que utilizará el form de `panelServicios.php` que inserta los datos.

Realmente este es el PHP que inserta el nuevo VPS, El form de `panelServicios.php` realiza una llamada a este PHP y añade el registro con los valores establecidos en el form

```php
<?php
$app = $_POST["app"];
$version = $_POST["version"];
$cliente = $_POST["cliente"];
$notificar = $_POST["notificar"];
$email = $_POST["email"];
include("conexion.php");
function consulta($conn,$query){
	$resultado = mysqli_query($conn,$query);
	return $resultado;
}
$res = consulta($conn,"INSERT INTO `servicios` (`app`,`version`, `cliente`, `notificar`,`email`) VALUES ('$app','$version', '$cliente','$notificar','$email');");
var_dump($res);
mysqli_close($conn); //cierra la conexion con MariaDB
?>
```

________________________________________
*[Volver al atrás...](../../webPHP.md)*
