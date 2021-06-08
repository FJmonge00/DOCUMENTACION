# En la parte superior se encuentan los ficheros PHP utilizados para interacturar via PHP con la OA y la Base de Datos

# Webs que conforman el Panel de Administración VPS

## Pagina Principal del Panel Administración VPS.

En esta web es donde interactua el Administrador con la OA y la base de datos. 

En esta web podremos:
- Acceder a los datos a través del form que tiene como `action` → `verTodosVPS.php`.
- Buscar en la base de datos a través del form que tiene como `action` → `buscarPorID.php`.
- Ver el ultimo vps lanzado con → `ultimoVPS.php`.
- Insertar y lanzar un VPS a través del form que tiene como `action` → `insertRegistrosOA.php`.

```php
<html>
	<head>
        <title>Admin OA VPS</title>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <meta charset="utf-8"/>
        <link rel="stylesheet" href="style.css">
	</head>
	<body>
		<div class="cabecera">
			<h1>Panel Administración VPS</h1>
		</div>
		<div class="Mostrar"> 
			<h2> Todos los VPS </h2>
			<form action= "verTodosVPS.php" method="post">
				<input type ="submit" value="Mostrar" />
			</form>
		</div>
		<div class="Busqueda">
			<h2> Búsqueda de VPS </h2>
			<form action= "buscarPorID.php" method="post">
				<b>id:</b><input type="text" name="identificador" size="4" maxlength="4" placeholder="Buscar VPS..."/> 
				<input type ="submit" value="Buscar" />
				<input type="Reset" value="Limpiar">
			</form>
		</div>
    	<br>
    	<br>
	<!-- <h1>________________________________________________________________________________________________</h1> -->
	<div class=Nuevo>
		<h2 style="text-align: center"> Ultimo VPS lanzado </h2>
		<table style="margin: 5px;margin-left: 50%;text-align: center;padding: 3px;" border=2>
			<tr>
				<td>Id</td>
			</tr>
			<?php
			include("ultimoVPS.php");
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
			<h2>Nuevo VPS</h2>
			<form action= "insertRegistrosOA.php" method="post">
				<br>
				<b>Cliente:</b>
				<input type="text" name="cliente" size="20" maxlength="80" required placeholder="Nombre Cliente..."> 
				<br>
				<br>
				<b>Procesador (vCPUs):</b>
				<input type="number" min="1" max="8" name="vcpu" required placeholder="2"> 
				<br>
				<br>
				<b>Memoria (vRAM):</b>
				<input type="number" min="1" max="20" name="vram" required placeholder="2"> 
				<br>
				<br>
				<b>Espacio en Disco (Nvme):</b>
				<input type="number" min="25" max="100" name="disco" required placeholder="25"> 
				<br>
				<br>
				<b> Sistema Operativo:</b>
				<br>
				<select name="so">
					<!-- Opciones de la lista -->
					<option value="Debian10">Debian 10</option>
					<option value="Centos8">Centos 8</option>
					<option value="UbuntuServer2004">Ubuntu Server 20.04</option>
					<option value="WindowsServer2019">Windows Server 2019</option>
				</select>
				<br>
				<br>
				<b>Plan VPS:</b>
				<br>
				<select name="plan">
					<!-- Opciones de la lista -->
					<option value="LampApache">LAMP (Apache)</option>
					<option value="mariadb">MariaDB</option>
					<option value="postgresql">PostgreSQL</option>
					<option value="LempNginx">LEMP (Nginx)</option>
					<option value="DockerDesarollo">Plan desarrollo docker</option>
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
				<input type="submit" value="Lanzar MV (VPS)">
				<br>
				<br>
				<input type="Reset" value="Limpiar">
			</form>
		</div>
	</body>
</html>
```

## CSS del Panel Administración VPS.

```css
.Nuevo, .Busqueda, .Mostrar {
    background: rgb(23,182,184);
    background: linear-gradient(0deg, rgba(23,182,184,1) 0%, rgba(233,162,9,1) 100%);
    box-shadow: 10px 10px grey;
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
    width: 100%;
  }
html,body {
    background-color: 250, 235, 215;
}
```

## PHP para ver Todos los VPS actuales y registrados en la Base de datos (`verTodosVPS.php`)

```php
<html>
	<head>
		<meta charset="UTF-8">
		<title>Todos los VPS</title>
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
	<h2> Listado de la tabla datos </h2>
	<table>
		<tr>
			<td>Identificador</td>
			<td>Sistema Opertivo</td>
			<td>Plan</td>
			<td>Cliente</td>
			<td>vCPUs</td>
			<td>vRAM</td>
			<td>Almacenamiento Nvme</td>
			<td>Aviso</td>
			<td>Email Contacto</td>
			<td>Fecha Solicitud</td>
			<td>Fecha Preparada</td>
		</tr>
		<?php
		include("ejecutaSelect.php");
		foreach($res as $registros){ ?>
		<tr>
			<td><?php echo $registros['id']?></td>
			<td><?php echo $registros['so']?></td>
			<td><?php echo $registros['plan']?></td>
			<td><?php echo $registros['cliente']?></td>
			<td><?php echo $registros['vcpu']?></td>
			<td><?php echo $registros['vram']?></td>
			<td><?php echo $registros['disco']?></td>
			<td><?php echo $registros['notificar']?></td>
			<td><?php echo $registros['email']?></td>
			<td><?php echo $registros['fechasolicitud']?></td>
			<td><?php echo $registros['fechapreparada']?></td>
		</tr>
		<?php }?>
	</table>
	</body>
</html>
```

## PHP que utilizará `verTodosVPS.php` para obtener los registros _(Depende de conexion.php)_.

Realmente esta es la parte del PHP que consulta los datos a MariaDB, `verTodosVPS.php` únicamente muestra lo que obtiene este PHP con la `mysqli_query`:

```php
<?php
include("conexion.php"); // Conexion con MariaDB y la base de datos
//Devuelve todos los registros de una tabla
function consulta($conn,$query){
	$resultado = mysqli_query($conn,$query);
	return $resultado;
}
$res = consulta($conn,"SELECT * FROM vps");
mysqli_close($conn); //cierra la conexion con MariaDB
?>
```

## PHP para buscar por el ID del VPS (`buscarPorID.php`)

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
			width: 100%;
			/* border: 2px solid black; */
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
		<h2> VPS </h2>
		<table>
			<tr>
				<td>Identificador</td>
				<td>Sistema Opertivo</td>
				<td>Plan</td>
				<td>Cliente</td>
				<td>vCPUs</td>
				<td>vRAM</td>
				<td>Almacenamiento Nvme</td>
				<td>Aviso</td>
				<td>Email Contacto</td>
				<td>Fecha Solicitud</td>
				<td>Fecha Preparada</td>
			</tr>
			<?php
			include("ejecutaSelectid.php");
			//$res está el resultado de ejecutaSelect.php
			foreach($res as $registros){ ?>
			<tr>
				<td><?php echo $registros['id']?></td>
				<td><?php echo $registros['so']?></td>
				<td><?php echo $registros['plan']?></td>
				<td><?php echo $registros['cliente']?></td>
				<td><?php echo $registros['vcpu']?></td>
				<td><?php echo $registros['vram']?></td>
				<td><?php echo $registros['disco']?></td>
				<td><?php echo $registros['notificar']?></td>
				<td><?php echo $registros['email']?></td>
				<td><?php echo $registros['fechasolicitud']?></td>
				<td><?php echo $registros['fechapreparada']?></td>
			</tr>
			<?php }?>
		</table>
	</body>
</html>
```

## PHP que utilizará `buscarPorID.php` para obtener el registro indicado _(Depende de conexion.php)_.

Realmente esta es la parte del PHP que consulta los datos a MariaDB, consulta el registro de `ID` con valor `X`, `buscarPorID.php` únicamente muestra lo que obtiene este PHP con la `mysqli_query`. (El id que consultará es el indicado en el form)

```php
<?php
//Recogida de datos a consultar
$identificador = $_POST["identificador"]; // Formulario
include("conexion.php");  // Conexion con MariaDB y Base de datos
function consulta($conn,$query){
	$resultado = mysqli_query($conn,$query);
	return $resultado;
}
$res = consulta($conn,"SELECT * FROM vps WHERE id='$identificador'");
mysqli_close($conn); //cierra la conexion con MariaDB
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

## PHP que utilizará el form de `panelVPS.php` que inserta los datos.

Realmente este es el PHP que inserta el nuevo VPS, El form de `panelVPS.php` realiza una llamada a este PHP y añade el registro con los valores establecidos en el form

```php
<<?php
$so = $_POST["so"];
$plan = $_POST["plan"];
$cliente = $_POST["cliente"];
$vcpu = $_POST["vcpu"];
$vram = $_POST["vram"];
$disco = $_POST["disco"];
$notificar = $_POST["notificar"];
$email = $_POST["email"];
include("conexion.php");
function consulta($conn,$query){
	$resultado = mysqli_query($conn,$query);
	return $resultado;
}
$res = consulta($conn,"INSERT INTO `vps` (`so`,`plan`,`cliente`,`vcpu`,`vram`,`disco`,`notificar`,`email`) VALUES ('$so','$plan','$cliente','$vcpu','$vram','$disco','$notificar','$email');");
var_dump($res);
mysqli_close($conn); //cierra la conexion con MariaDB
?>
```