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
				<b>id:</b><input type="text" name="identificador" size="4" maxlength="4" placeholder="Buscar Servicio..."/> 
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
				<input type="number" min="1" max="8" name="vram" required placeholder="2"> 
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
