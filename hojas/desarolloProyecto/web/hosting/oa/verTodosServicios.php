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