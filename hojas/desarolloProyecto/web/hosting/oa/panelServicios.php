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
			<form action= "verTodosServicios.php" method="post">
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
			<form action= "insertRegistrosOA.php" method="post">
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
